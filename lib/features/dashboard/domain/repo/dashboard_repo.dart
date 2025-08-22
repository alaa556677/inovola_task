import 'package:dartz/dartz.dart';
import '../../../../core/failure/failure.dart';
import '../../../add_expense/domain/entities/expense_entity.dart';

abstract class DashboardRepository {
  Future<Either<Failure, List<ExpenseEntity>>> getAllExpenses({
    String? filterType,
    int? page,
    int? limit,
  });

  Future<Either<Failure, Map<String, double>>> getExpensesSummary({
    String? filterType,
  });
}
