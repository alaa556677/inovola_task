import 'package:dartz/dartz.dart';
import '../../../../core/failure/failure.dart';
import '../../../dashboard/domain/repo/expense_repo.dart';
import '../entities/expense_entity.dart';

class AddExpenseUseCase {
  final ExpenseRepository expenseRepository;

  AddExpenseUseCase(this.expenseRepository);

  Future<Either<Failure, ExpenseEntity>> call(ExpenseEntity expense) async {
    return await expenseRepository.addExpense(expense);
  }
}
