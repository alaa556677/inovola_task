import 'package:equatable/equatable.dart';
import '../../../add_expense/domain/entities/expense_entity.dart';

abstract class DashboardStates extends Equatable {
  const DashboardStates();

  @override
  List<Object?> get props => [];
}

class DashBoardInitial extends DashboardStates {}

class GetAllExpensesLoading extends DashboardStates {}

class GetAllExpensesSuccess extends DashboardStates {
  final List<ExpenseEntity> expensesList;
  final String? currentFilter;


  const GetAllExpensesSuccess({
    required this.expensesList,
    this.currentFilter,

  });

  @override
  List<Object?> get props => [expensesList, currentFilter];
}

class GetAllExpensesLastPage extends DashboardStates{
  final List<ExpenseEntity> expensesList;
  GetAllExpensesLastPage(this.expensesList);
}

class GetAllExpensesError extends DashboardStates {
  final String errorMessage;

  const GetAllExpensesError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class DashboardSummaryLoading extends DashboardStates {}

class DashboardSummaryLoaded extends DashboardStates {
  final double totalBalance;
  final double totalIncome;
  final double totalExpenses;
  final String? currentFilter;

  const DashboardSummaryLoaded({
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpenses,
    this.currentFilter,
  });

  @override
  List<Object?> get props =>
      [totalBalance, totalIncome, totalExpenses, currentFilter];
}

class DashboardSummaryError extends DashboardStates {
  final String errorMessage;

  const DashboardSummaryError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
