import 'package:equatable/equatable.dart';

import '../../domain/entities/expense_entity.dart';

abstract class ExpenseState extends Equatable {
  const ExpenseState();
  @override
  List<Object?> get props => [];
}
////////////////////////////////////////////////////////////////////////////////
class ExpenseInitial extends ExpenseState {}
////////////////////////////////////////////////////////////////////////////////
class AddExpenseLoading extends ExpenseState {}
class AddExpenseSuccess extends ExpenseState {
  final ExpenseEntity expense;
  const AddExpenseSuccess(this.expense);
  @override
  List<Object?> get props => [expense];
}
class AddExpenseError extends ExpenseState {
  final String errorMessage;
  const AddExpenseError(this.errorMessage);
  @override
  List<Object?> get props => [errorMessage];
}
////////////////////////////////////////////////////////////////////////////////
class FormValidationState extends ExpenseState {
  final bool isValid;
  final Map<String, String> errors;
  const FormValidationState({
    required this.isValid,
    required this.errors,
  });
  @override
  List<Object?> get props => [isValid, errors];
}
////////////////////////////////////////////////////////////////////////////////
class CurrencyLoading extends ExpenseState {}

class CurrencyLoaded extends ExpenseState {
  final Map<String, double> rates;
  const CurrencyLoaded(this.rates);
}

class CurrencyConverted extends ExpenseState {
  final double result;
  const CurrencyConverted(this.result);
}

class CurrencyError extends ExpenseState {
  final String message;
  const CurrencyError(this.message);
}
////////////////////////////////////////////////////////////////////////////////