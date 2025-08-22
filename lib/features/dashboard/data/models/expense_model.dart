import 'package:hive/hive.dart';

import '../../../add_expense/domain/entities/expense_entity.dart';

part 'expense_model.g.dart';

@HiveType(typeId: 0)
class ExpenseModel extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String category;
  
  @HiveField(2)
  final double amount;
  
  @HiveField(3)
  final String currency;
  
  @HiveField(4)
  final double convertedAmount;
  
  @HiveField(5)
  final DateTime date;
  
  @HiveField(6)
  final String? receiptPath;
  
  @HiveField(7)
  final String? notes;
  
  @HiveField(8)
  final String type;

  ExpenseModel({
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

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] ?? '',
      category: json['category'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      currency: json['currency'] ?? 'USD',
      convertedAmount: (json['convertedAmount'] ?? 0.0).toDouble(),
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      receiptPath: json['receiptPath'],
      notes: json['notes'],
      type: json['type'] ?? 'expense',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'amount': amount,
      'currency': currency,
      'convertedAmount': convertedAmount,
      'date': date.toIso8601String(),
      'receiptPath': receiptPath,
      'notes': notes,
      'type': type,
    };
  }

  factory ExpenseModel.fromEntity(ExpenseEntity entity) {
    return ExpenseModel(
      id: entity.id,
      category: entity.category,
      amount: entity.amount,
      currency: entity.currency,
      convertedAmount: entity.convertedAmount,
      date: entity.date,
      receiptPath: entity.receiptPath,
      notes: entity.notes,
      type: entity.type,
    );
  }

  ExpenseEntity toEntity() {
    return ExpenseEntity(
      id: id,
      category: category,
      amount: amount,
      currency: currency,
      convertedAmount: convertedAmount,
      date: date,
      receiptPath: receiptPath,
      notes: notes,
      type: type,
    );
  }
}
