import 'package:dartz/dartz.dart';
import '../../../../core/failure/failure.dart';
import '../entities/expense_entity.dart';

abstract class ExpenseRepository {
  /// Get all expenses with optional filtering
  Future<Either<Failure, List<ExpenseEntity>>> getAllExpenses({
    String? filterType,
    int? page,
    int? limit,
  });

  /// Add a new expense
  Future<Either<Failure, ExpenseEntity>> addExpense(ExpenseEntity expense);

  /// Update an existing expense
  Future<Either<Failure, ExpenseEntity>> updateExpense(ExpenseEntity expense);

  /// Delete an expense
  Future<Either<Failure, bool>> deleteExpense(String id);

  /// Get expense by ID
  Future<Either<Failure, ExpenseEntity?>> getExpenseById(String id);

  /// Get expenses summary (totals, balances)
  Future<Either<Failure, Map<String, double>>> getExpensesSummary({
    String? filterType,
  });

  /// Get expenses by category
  Future<Either<Failure, Map<String, double>>> getExpensesByCategory({
    String? filterType,
  });
}
