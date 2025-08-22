import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:inovola_task/core/failure/failure.dart';
import 'package:inovola_task/features/add_expense/domain/entities/expense_entity.dart';
import '../../domain/repo/addExpense_repo.dart';
import '../models/expense_model.dart';

class AddExpenseRepoImpl implements AddExpenseRepository {
  static const String _boxName = 'expenses';
  late Box<ExpenseModel> _expenseBox;

  AddExpenseRepoImpl() {
    _initBox();
  }

  Future<void> _initBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _expenseBox = await Hive.openBox<ExpenseModel>(_boxName);
    } else {
      _expenseBox = Hive.box<ExpenseModel>(_boxName);
    }
  }

  @override
  Future<Either<Failure, ExpenseEntity>> addExpense(ExpenseEntity expense) async {
    try {
      await _initBox();
      print('ExpenseRepository: Adding expense - ${expense.category}: ${expense.amount} ${expense.currency}');

      final model = ExpenseModel.fromEntity(expense);
      await _expenseBox.add(model);
      print('ExpenseRepository: Successfully added expense to box');

      return Right(expense);
    } catch (e) {
      print('ExpenseRepository: Error adding expense: $e');
      return Left(Failure('Failed to add expense: ${e.toString()}'));
    }
  }

}