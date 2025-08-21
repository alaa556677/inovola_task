import 'package:dartz/dartz.dart';
import '../../../../core/failure/failure.dart';
import '../entities/expense_entity.dart';
import '../repo/expense_repo.dart';

class AddExpenseUseCase {
  final ExpenseRepository expenseRepository;

  AddExpenseUseCase(this.expenseRepository);

  Future<Either<Failure, ExpenseEntity>> call(ExpenseEntity expense) async {
    return await expenseRepository.addExpense(expense);
  }
}
