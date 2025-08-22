import 'package:dartz/dartz.dart';
import '../../../../core/failure/failure.dart';
import '../entities/expense_entity.dart';

abstract class AddExpenseRepository {
  Future<Either<Failure, ExpenseEntity>> addExpense(ExpenseEntity expense);
  Future<Map<String, double>> getExchangeRates();
  Future<double> convertToUSD(double amount, String fromCurrency);
  Future<double> convertFromUSD(double amount, String toCurrency);
}