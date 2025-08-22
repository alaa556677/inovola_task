import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovola_task/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:inovola_task/features/dashboard/presentation/bloc/dashboard_state.dart';
import '../../../../core/services/cancel_token.dart';
import '../../../add_expense/domain/entities/expense_entity.dart';
import '../../domain/useCase/get_AllExpense_useCase.dart';
import '../../domain/useCase/get_expenses_summary_use_case.dart';
import 'package:flutter/material.dart';

class DashboardBloc extends Bloc<DashboardEvents, DashboardStates>
    with BlocCancelToken<DashboardEvents, DashboardStates> {
  final GetExpenseUseCase getExpenseUseCase;
  final GetExpensesSummaryUseCase getExpensesSummaryUseCase;

  DashboardBloc({
    required this.getExpenseUseCase,
    required this.getExpensesSummaryUseCase,
  }) : super(DashBoardInitial()) {
    on<DashboardEvents>((event, emit) async {
      if (event is GetAllExpensesEvents) {
        await _handleGetAllExpenses(event, emit);
      } else if (event is LoadDashboardSummary) {
        await _handleLoadDashboardSummary(event, emit);
      } else if (event is RefreshAllExpensesEvents) {
        await _handleRefreshExpenses(event, emit);
      } else if (event is ApplyFilter) {
        await _handleApplyFilter(event, emit);
      } else if (event is AddSingleExpense) {
        await _handleAddSingleExpense(event, emit);
      }
    });
  }
////////////////////////////////////////////////////////////////////////////////
  List<ExpenseEntity> expensesList = [];
  String? filterType;
  int currentPage = 1;
  final int pageSize = 10;
  bool hasMore = true;
  bool isLoadingMore = false;

  // Store summary data to preserve it across state changes
  double? _lastTotalBalance;
  double? _lastTotalIncome;
  double? _lastTotalExpenses;

  // Getters for stored summary data
  double get lastTotalBalance => _lastTotalBalance ?? 0.0;
  double get lastTotalIncome => _lastTotalIncome ?? 0.0;
  double get lastTotalExpenses => _lastTotalExpenses ?? 0.0;

  Future<void> _handleGetAllExpenses(
      GetAllExpensesEvents event, Emitter<DashboardStates> emit) async {
    if (event.isLoadMore) {
      if (isLoadingMore || !hasMore) return; // Prevent duplicate loading
      isLoadingMore = true;
      safeEmit(GetAllExpensesLoading(), emit);
    } else {
      // Only reset for new filter, preserve list for refresh
      if (filterType != event.filterType) {
        currentPage = 1;
        hasMore = true;
        expensesList.clear();
      }
      safeEmit(GetAllExpensesLoading(), emit);
    }

    final result = await getExpenseUseCase(
      cancelToken: cancelToken,
      filterType: event.filterType,
      page: currentPage,
      limit: pageSize,
    );

    result.fold(
      (failure) {
        debugPrint(
            'DashboardBloc: Failed to load expenses: ${failure.errorMessage}');
        safeEmit(GetAllExpensesError(failure.errorMessage), emit);
      },
      (expenses) {
        debugPrint(
            'DashboardBloc: Successfully loaded ${expenses.length} expenses');

        if (event.isLoadMore) {
          // Add to existing list for pagination
          expensesList.addAll(expenses);
        } else {
          // Replace list for new filter or refresh
          expensesList = List.from(expenses);
        }

        if (expenses.isEmpty) {
          hasMore = false;
        } else {
          hasMore = expenses.length == pageSize;
          if (event.isLoadMore) {
            currentPage++;
          } else {
            currentPage = 2; // Set to 2 for next page load
          }
        }

        filterType = event.filterType ?? 'All';

        // Update stored summary data based on current expenses list
        _updateStoredSummaryFromExpenses();

        safeEmit(
          GetAllExpensesSuccess(
            expensesList: List.from(expensesList),
            currentFilter: filterType,
            hasMore: hasMore,
          ),
          emit,
        );
      },
    );

    isLoadingMore = false;
  }

////////////////////////////////////////////////////////////////////////////////
  Future<void> _handleLoadDashboardSummary(
      LoadDashboardSummary event, Emitter<DashboardStates> emit) async {
    safeEmit(DashboardSummaryLoading(), emit);
    final result =
        await getExpensesSummaryUseCase(filterType: event.filterType);
    result.fold(
      (failure) {
        safeEmit(DashboardSummaryError(failure.errorMessage), emit);
      },
      (summary) {
        // Only use API summary if we don't have expenses loaded yet
        // Otherwise, calculate from current expenses to keep it in sync
        if (expensesList.isEmpty) {
          _lastTotalBalance = summary['totalBalance'] ?? 0.0;
          _lastTotalIncome = summary['totalIncome'] ?? 0.0;
          _lastTotalExpenses = summary['totalExpenses'] ?? 0.0;
        } else {
          // Update from current expenses to ensure accuracy
          _updateStoredSummaryFromExpenses();
        }

        safeEmit(
            DashboardSummaryLoaded(
              totalBalance: _lastTotalBalance!,
              totalIncome: _lastTotalIncome!,
              totalExpenses: _lastTotalExpenses!,
              currentFilter: event.filterType,
            ),
            emit);
      },
    );
  }

////////////////////////////////////////////////////////////////////////////////
  Future<void> _handleRefreshExpenses(
      RefreshAllExpensesEvents event, Emitter<DashboardStates> emit) async {
    debugPrint(
        'DashboardBloc: Refreshing expenses with filter: ${event.filterType}');
    // Reset pagination and reload expenses
    currentPage = 1;
    hasMore = true;
    expensesList.clear();
    await _handleGetAllExpenses(
      GetAllExpensesEvents(filterType: event.filterType),
      emit,
    );
  }

////////////////////////////////////////////////////////////////////////////////
  Future<void> _handleApplyFilter(
      ApplyFilter event, Emitter<DashboardStates> emit) async {
    debugPrint('DashboardBloc: Applying filter: ${event.filterType}');
    // Reset pagination and reload expenses with new filter
    currentPage = 1;
    hasMore = true;
    expensesList.clear();
    await _handleGetAllExpenses(
      GetAllExpensesEvents(filterType: event.filterType),
      emit,
    );
    // Also reload summary for new filter
    await _handleLoadDashboardSummary(
      LoadDashboardSummary(filterType: event.filterType),
      emit,
    );
  }

  Future<void> _handleAddSingleExpense(
      AddSingleExpense event, Emitter<DashboardStates> emit) async {
    debugPrint(
        'DashboardBloc: Adding single expense with filter: ${event.filterType}');
    // Refresh expenses and then emit updated summary
    await _handleGetAllExpenses(
      GetAllExpensesEvents(filterType: event.filterType),
      emit,
    );

    // Emit updated summary state after expenses are refreshed
    if (_lastTotalBalance != null) {
      safeEmit(
        DashboardSummaryLoaded(
          totalBalance: _lastTotalBalance!,
          totalIncome: _lastTotalIncome!,
          totalExpenses: _lastTotalExpenses!,
          currentFilter: event.filterType,
        ),
        emit,
      );
    }
  }

  // Helper method to update stored summary from current expenses list
  void _updateStoredSummaryFromExpenses() {
    if (expensesList.isEmpty) return;

    double totalIncome = 0.0;
    double totalExpenses = 0.0;

    for (final expense in expensesList) {
      if (expense.type == 'income') {
        totalIncome += expense.convertedAmount;
      } else {
        totalExpenses += expense.convertedAmount;
      }
    }

    _lastTotalIncome = totalIncome;
    _lastTotalExpenses = totalExpenses;
    _lastTotalBalance = totalIncome - totalExpenses;

    debugPrint(
        'DashboardBloc: Updated stored summary from ${expensesList.length} expenses - Balance: $_lastTotalBalance, Income: $_lastTotalIncome, Expenses: $_lastTotalExpenses');
  }
////////////////////////////////////////////////////////////////////////////////
}
