import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/failure/failure.dart';
import '../../../add_expense/domain/entities/expense_entity.dart';
import '../repo/dashboard_repo.dart';

class GetExpenseUseCase {
  final DashboardRepository expenseRepository;
  GetExpenseUseCase(this.expenseRepository);

  Future<Either<Failure, List<ExpenseEntity>>> call({CancelToken? cancelToken, String? filterType,  int? page,
    int? limit,}) async {
    return await expenseRepository.getAllExpenses(filterType: filterType, page: page, limit: limit);
  }
}
