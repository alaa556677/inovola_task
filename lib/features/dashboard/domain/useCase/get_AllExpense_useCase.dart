import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/failure/failure.dart';
import '../../../add_expense/domain/entities/expense_entity.dart';
import '../repo/expense_repo.dart';

class GetExpenseUseCase {
  final ExpenseRepository expenseRepository;
  GetExpenseUseCase(this.expenseRepository);

  Future<Either<Failure, List<ExpenseEntity>>> call(
      {CancelToken? cancelToken, String? filterType}) async {
    return await expenseRepository.getAllExpenses(filterType: filterType);
  }
}
