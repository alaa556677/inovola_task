import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/failure/failure.dart';
import '../../../add_expense/domain/entities/expense_entity.dart';
import '../repo/dashboard_repo.dart';

class GetExpenseUseCase {
  final DashboardRepository expenseRepository;
  GetExpenseUseCase(this.expenseRepository);

<<<<<<< HEAD
  Future<Either<Failure, List<ExpenseEntity>>> call({CancelToken? cancelToken, String? filterType,  int? page,
    int? limit,}) async {
=======
  Future<Either<Failure, List<ExpenseEntity>>> call(
      {CancelToken? cancelToken, String? filterType,  int? page, int? limit,}) async {
>>>>>>> 176486876e7b4bf114dfed15146c5c2be23792a4
    return await expenseRepository.getAllExpenses(filterType: filterType, page: page, limit: limit);
  }
}
