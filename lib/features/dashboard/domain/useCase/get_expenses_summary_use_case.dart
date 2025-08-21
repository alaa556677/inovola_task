import 'package:dartz/dartz.dart';
import '../../../../core/failure/failure.dart';
import '../repo/expense_repo.dart';

class GetExpensesSummaryUseCase {
  final ExpenseRepository expenseRepository;

  GetExpensesSummaryUseCase(this.expenseRepository);

  Future<Either<Failure, Map<String, double>>> call(
      {String? filterType}) async {
    return await expenseRepository.getExpensesSummary(filterType: filterType);
  }
}
