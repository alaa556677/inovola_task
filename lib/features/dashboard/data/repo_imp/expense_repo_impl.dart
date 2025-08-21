import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import '../../../../core/failure/failure.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/repo/expense_repo.dart';
import '../models/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  static const String _boxName = 'expenses';
  late Box<ExpenseModel> _expenseBox;

  ExpenseRepositoryImpl() {
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
  Future<Either<Failure, List<ExpenseEntity>>> getAllExpenses({
    String? filterType,
    int? page,
    int? limit,
  }) async {
    try {
      await _initBox();

      List<ExpenseModel> expenses = _expenseBox.values.toList();

      // Apply filter if specified
      if (filterType != null) {
        expenses = _applyFilter(expenses, filterType);
      }

      // Sort by date (newest first)
      expenses.sort((a, b) => b.date.compareTo(a.date));

      // Apply pagination
      if (page != null && limit != null) {
        final startIndex = page * limit;
        final endIndex = (startIndex + limit).clamp(0, expenses.length);
        expenses = expenses.sublist(startIndex, endIndex);
      }

      final entities = expenses.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(Failure('Failed to get expenses: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ExpenseEntity>> addExpense(
      ExpenseEntity expense) async {
    try {
      await _initBox();

      final model = ExpenseModel.fromEntity(expense);
      await _expenseBox.add(model);

      return Right(expense);
    } catch (e) {
      return Left(Failure('Failed to add expense: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ExpenseEntity>> updateExpense(
      ExpenseEntity expense) async {
    try {
      await _initBox();

      final key = _expenseBox.keys.firstWhere(
        (key) => _expenseBox.get(key)?.id == expense.id,
        orElse: () => -1,
      );

      if (key == -1) {
        return Left(Failure('Expense not found'));
      }

      final model = ExpenseModel.fromEntity(expense);
      await _expenseBox.put(key, model);

      return Right(expense);
    } catch (e) {
      return Left(Failure('Failed to update expense: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteExpense(String id) async {
    try {
      await _initBox();

      final key = _expenseBox.keys.firstWhere(
        (key) => _expenseBox.get(key)?.id == id,
        orElse: () => -1,
      );

      if (key == -1) {
        return Left(Failure('Expense not found'));
      }

      await _expenseBox.delete(key);
      return const Right(true);
    } catch (e) {
      return Left(Failure('Failed to delete expense: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ExpenseEntity?>> getExpenseById(String id) async {
    try {
      await _initBox();

      final expense = _expenseBox.values.firstWhere(
        (expense) => expense.id == id,
        orElse: () => ExpenseModel(
          id: '',
          category: '',
          amount: 0,
          currency: 'USD',
          convertedAmount: 0,
          date: DateTime.now(),
          type: 'expense',
        ),
      );

      if (expense.id.isEmpty) {
        return const Right(null);
      }

      return Right(expense?.toEntity());
    } catch (e) {
      return Left(Failure('Failed to get expense: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Map<String, double>>> getExpensesSummary({
    String? filterType,
  }) async {
    try {
      await _initBox();

      List<ExpenseModel> expenses = _expenseBox.values.toList();

      if (filterType != null) {
        expenses = _applyFilter(expenses, filterType);
      }

      double totalIncome = 0;
      double totalExpenses = 0;

      for (final expense in expenses) {
        if (expense.type == 'income') {
          totalIncome += expense.convertedAmount;
        } else {
          totalExpenses += expense.convertedAmount;
        }
      }

      final totalBalance = totalIncome - totalExpenses;

      return Right({
        'totalBalance': totalBalance,
        'totalIncome': totalIncome,
        'totalExpenses': totalExpenses,
      });
    } catch (e) {
      return Left(Failure('Failed to get expenses summary: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Map<String, double>>> getExpensesByCategory({
    String? filterType,
  }) async {
    try {
      await _initBox();

      List<ExpenseModel> expenses = _expenseBox.values.toList();

      if (filterType != null) {
        expenses = _applyFilter(expenses, filterType);
      }

      final Map<String, double> categoryTotals = {};

      for (final expense in expenses) {
        final category = expense.category;
        final amount = expense.convertedAmount;

        if (expense.type == 'expense') {
          categoryTotals[category] = (categoryTotals[category] ?? 0) + amount;
        }
      }

      return Right(categoryTotals);
    } catch (e) {
      return Left(
          Failure('Failed to get expenses by category: ${e.toString()}'));
    }
  }

  List<ExpenseModel> _applyFilter(
      List<ExpenseModel> expenses, String filterType) {
    final now = DateTime.now();

    switch (filterType) {
      case 'This Month':
        return expenses.where((expense) {
          return expense.date.year == now.year &&
              expense.date.month == now.month;
        }).toList();

      case 'Last 7 Days':
        final sevenDaysAgo = now.subtract(const Duration(days: 7));
        return expenses.where((expense) {
          return expense.date.isAfter(sevenDaysAgo);
        }).toList();

      case 'Last 30 Days':
        final thirtyDaysAgo = now.subtract(const Duration(days: 30));
        return expenses.where((expense) {
          return expense.date.isAfter(thirtyDaysAgo);
        }).toList();

      default:
        return expenses;
    }
  }
}
