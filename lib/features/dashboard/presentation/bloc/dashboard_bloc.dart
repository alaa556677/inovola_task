import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovola_task/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:inovola_task/features/dashboard/presentation/bloc/dashboard_state.dart';
import '../../../../core/services/cancel_token.dart';
import '../../domain/useCase/get_expense_useCase.dart';
import '../../domain/useCase/get_expenses_summary_use_case.dart';

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
      }
    });
  }

  Future<void> _handleGetAllExpenses(
      GetAllExpensesEvents event, Emitter<DashboardStates> emit) async {
    print('DashboardBloc: Loading expenses with filter: ${event.filterType}');
    safeEmit(GetAllExpensesLoading(), emit);
    final result = await getExpenseUseCase(
      cancelToken: cancelToken,
      filterType: event.filterType,
    );
    result.fold(
      (failure) {
        print('DashboardBloc: Failed to load expenses: ${failure.errorMessage}');
        safeEmit(GetAllExpensesError(failure.errorMessage), emit);
      },
      (expenses) {
        print('DashboardBloc: Successfully loaded ${expenses.length} expenses');
        for (var expense in expenses) {
          print('DashboardBloc: Expense - ${expense.category}: ${expense.amount} ${expense.currency} on ${expense.date}');
        }
        safeEmit(
            GetAllExpensesSuccess(
              expensesList: expenses,
              currentFilter: event.filterType,
            ),
            emit);
      },
    );
  }

  Future<void> _handleLoadDashboardSummary(
      LoadDashboardSummary event, Emitter<DashboardStates> emit) async {
    print('DashboardBloc: Loading summary with filter: ${event.filterType}');
    safeEmit(DashboardSummaryLoading(), emit);
    final result =
        await getExpensesSummaryUseCase(filterType: event.filterType);
    result.fold(
      (failure) {
        print('DashboardBloc: Failed to load summary: ${failure.errorMessage}');
        safeEmit(DashboardSummaryError(failure.errorMessage), emit);
      },
      (summary) {
        print('DashboardBloc: Summary loaded - Balance: ${summary['totalBalance']}, Income: ${summary['totalIncome']}, Expenses: ${summary['totalExpenses']}');
        safeEmit(
            DashboardSummaryLoaded(
              totalBalance: summary['totalBalance'] ?? 0.0,
              totalIncome: summary['totalIncome'] ?? 0.0,
              totalExpenses: summary['totalExpenses'] ?? 0.0,
              currentFilter: event.filterType,
            ),
            emit);
      },
    );
  }

  Future<void> _handleRefreshExpenses(
      RefreshAllExpensesEvents event, Emitter<DashboardStates> emit) async {
    print('DashboardBloc: Refreshing expenses with filter: ${event.filterType}');
    // Instead of calling add(), we'll handle this in the UI
    // The UI should call both events separately
  }

  Future<void> _handleApplyFilter(
      ApplyFilter event, Emitter<DashboardStates> emit) async {
    print('DashboardBloc: Applying filter: ${event.filterType}');
    // Instead of calling add(), we'll handle this in the UI
    // The UI should call both events separately
  }
}
