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
        await _handleGetExpensesPage(event, emit);
      } else if (event is LoadDashboardSummary) {
        await _handleLoadDashboardSummary(event, emit);
      } else if (event is RefreshAllExpensesEvents) {
        await _handleRefreshExpenses(event, emit);
      } else if (event is ApplyFilter) {
        await _handleApplyFilter(event, emit);
      }
    });
  }
////////////////////////////////////////////////////////////////////////////////
  List<ExpenseEntity> expensesList = [];
  String? filterType;
  Future<void> _handleGetExpensesPage(GetAllExpensesEvents event, Emitter<DashboardStates> emit) async {
    debugPrint(
        'DashboardBloc: Loading page ${event.page} with size ${event.pageSize}, filter: ${event.filterType}');
    if (event.page == 1) {
      safeEmit(GetAllExpensesLoading(), emit);
    }

    final result = await getExpenseUseCase(
      cancelToken: cancelToken,
      filterType: event.filterType,
      page: event.page,
      pageSize: event.pageSize,
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
        for (var expense in expenses) {
          debugPrint(
              'DashboardBloc: Expense - ${expense.category}: ${expense.amount} ${expense.currency} on ${expense.date}');
        }

        if (event.page == 1) {
          expensesList = expenses;
        } else {
          expensesList.addAll(expenses);
        }

        filterType = event.filterType ?? 'All';

        safeEmit(
          GetAllExpensesSuccess(
            expensesList: expensesList,
            hasMore: expenses.length == event.pageSize, // لو رجع أقل من pageSize يبقى خلصت
            currentFilter: filterType,
          ),
          emit,
        );
      },
    );
  }

////////////////////////////////////////////////////////////////////////////////
  Future<void> _handleLoadDashboardSummary(LoadDashboardSummary event, Emitter<DashboardStates> emit) async {
    safeEmit(DashboardSummaryLoading(), emit);
    final result = await getExpensesSummaryUseCase(filterType: event.filterType);
    result.fold(
      (failure) {
        safeEmit(DashboardSummaryError(failure.errorMessage), emit);
      },
      (summary) {
        safeEmit(
          DashboardSummaryLoaded(
            totalBalance: summary['totalBalance'] ?? 0.0,
            totalIncome: summary['totalIncome'] ?? 0.0,
            totalExpenses: summary['totalExpenses'] ?? 0.0,
            currentFilter: event.filterType,
          ),emit);
      },
    );
  }
////////////////////////////////////////////////////////////////////////////////
  Future<void> _handleRefreshExpenses(RefreshAllExpensesEvents event, Emitter<DashboardStates> emit) async {
    debugPrint('DashboardBloc: Refreshing expenses with filter: ${event.filterType}');
  }
////////////////////////////////////////////////////////////////////////////////
  Future<void> _handleApplyFilter(ApplyFilter event, Emitter<DashboardStates> emit) async {
    debugPrint('DashboardBloc: Applying filter: ${event.filterType}');
  }
////////////////////////////////////////////////////////////////////////////////
}
