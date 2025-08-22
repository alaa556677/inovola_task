import 'package:equatable/equatable.dart';

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();
  @override
  List<Object?> get props => [];
}
////////////////////////////////////////////////////////////////////////////////
class AddExpense extends ExpenseEvent {
  final String category;
  final double amount;
  final String currency;
  final DateTime date;
  final String? receiptPath;
  final String? notes;
  final String type;
  const AddExpense({
    required this.category,
    required this.amount,
    required this.currency,
    required this.date,
    this.receiptPath,
    this.notes,
    required this.type,
  });
  @override
  List<Object?> get props => [category, amount, currency, date, receiptPath, notes, type];
}
////////////////////////////////////////////////////////////////////////////////
class SelectCategory extends ExpenseEvent {
  final String category;
  const SelectCategory(this.category);
  @override
  List<Object?> get props => [category];
}
////////////////////////////////////////////////////////////////////////////////
class SelectCurrency extends ExpenseEvent {
  final String currency;
  const SelectCurrency(this.currency);
  @override
  List<Object?> get props => [currency];
}
////////////////////////////////////////////////////////////////////////////////
class UploadReceipt extends ExpenseEvent {
  final String? receiptPath;
  const UploadReceipt(this.receiptPath);
  @override
  List<Object?> get props => [receiptPath];
}
////////////////////////////////////////////////////////////////////////////////
class ValidateForm extends ExpenseEvent {
  final String category;
  final String amount;
  final String currency;
  final DateTime date;
  const ValidateForm({
    required this.category,
    required this.amount,
    required this.currency,
    required this.date,
  });
  @override
  List<Object?> get props => [category, amount, currency, date];
}
////////////////////////////////////////////////////////////////////////////////
class GetRatesEvent extends ExpenseEvent {}
////////////////////////////////////////////////////////////////////////////////
class ConvertToUSDEvent extends ExpenseEvent {
  final double amount;
  final String fromCurrency;
  const ConvertToUSDEvent(this.amount, this.fromCurrency);
}
////////////////////////////////////////////////////////////////////////////////
class ConvertFromUSDEvent extends ExpenseEvent {
  final double amount;
  final String toCurrency;
  const ConvertFromUSDEvent(this.amount, this.toCurrency);
}
////////////////////////////////////////////////////////////////////////////////