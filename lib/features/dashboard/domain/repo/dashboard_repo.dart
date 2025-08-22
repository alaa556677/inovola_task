import 'package:dartz/dartz.dart';
import '../../../../core/failure/failure.dart';
import '../../../add_expense/domain/entities/expense_entity.dart';

abstract class DashboardRepository {
  /// Get all expenses with optional filtering
  Future<Either<Failure, List<ExpenseEntity>>> getAllExpenses({
    String? filterType,
    int? page,
    int? pageSize
  });

  /// Add a new expense



  /// Get expenses summary (totals, balances)
  Future<Either<Failure, Map<String, double>>> getExpensesSummary({
    String? filterType,
  });

}
