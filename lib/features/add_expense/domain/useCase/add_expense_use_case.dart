import 'package:dartz/dartz.dart';
import '../../../../core/failure/failure.dart';
import '../entities/expense_entity.dart';
import '../repo/addExpense_repo.dart';

class AddExpenseUseCase {
  final AddExpenseRepository addExpenseRepository;

  AddExpenseUseCase(this.addExpenseRepository);

  Future<Either<Failure, ExpenseEntity>> call(ExpenseEntity expense) async {
    return await addExpenseRepository.addExpense(expense);
  }
}
