import 'package:equatable/equatable.dart';
import 'package:inovola_task/features/dashboard/domain/entities/get_expenses_entity.dart';

abstract class DashboardStates extends Equatable{
  const DashboardStates();
  @override
  List<Object?> get props => [];
}
////////////////////////////////////////////////////////////////////////////////
class DashBoardInitial extends DashboardStates{}
////////////////////////////////////////////////////////////////////////////////
class GetAllExpensesLoading extends DashboardStates{}
class GetAllExpensesError extends DashboardStates{
  final String errorMessage;
  const GetAllExpensesError(this.errorMessage);
  @override
  List<Object?> get props => [errorMessage];
}
class GetAllExpensesSuccess extends DashboardStates{
  final List<GetExpenseEntity> expensesList;
  const GetAllExpensesSuccess(this.expensesList);
  @override
  List<Object?> get props => [expensesList];
}
////////////////////////////////////////////////////////////////////////////////