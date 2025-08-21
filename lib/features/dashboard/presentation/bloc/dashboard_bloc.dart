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
    safeEmit(GetAllExpensesLoading(), emit);
    final result = await getExpenseUseCase(cancelToken);
    result.fold(
      (failure) {
        safeEmit(GetAllExpensesError(failure.errorMessage), emit);
      },
      (expenses) {
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
    safeEmit(DashboardSummaryLoading(), emit);
    final result =
        await getExpensesSummaryUseCase(filterType: event.filterType);
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
            ),
            emit);
      },
    );
  }

  Future<void> _handleRefreshExpenses(
      RefreshAllExpensesEvents event, Emitter<DashboardStates> emit) async {
    // Refresh both expenses and summary
    add(GetAllExpensesEvents(filterType: event.filterType));
    add(LoadDashboardSummary(filterType: event.filterType));
  }

  Future<void> _handleApplyFilter(
      ApplyFilter event, Emitter<DashboardStates> emit) async {
    // Apply filter and reload data
    add(GetAllExpensesEvents(filterType: event.filterType));
    add(LoadDashboardSummary(filterType: event.filterType));
  }
}
