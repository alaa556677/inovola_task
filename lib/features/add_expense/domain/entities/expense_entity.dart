import 'package:equatable/equatable.dart';

class ExpenseEntity extends Equatable {
  final String id;
  final String category;
  final double amount;
  final String currency;
  final double convertedAmount;
  final DateTime date;
  final String? receiptPath;
  final String? notes;
  final String type; // 'income' or 'expense'

  const ExpenseEntity({
    required this.id,
    required this.category,
    required this.amount,
    required this.currency,
    required this.convertedAmount,
    required this.date,
    this.receiptPath,
    this.notes,
    required this.type,
  });

  @override
  List<Object?> get props => [
        id,
        category,
        amount,
        currency,
        convertedAmount,
        date,
        receiptPath,
        notes,
        type,
      ];
}
