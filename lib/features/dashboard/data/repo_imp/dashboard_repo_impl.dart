import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import '../../../../core/failure/failure.dart';
import '../../../add_expense/data/models/expense_model.dart';
import '../../../add_expense/domain/entities/expense_entity.dart';
import '../../domain/repo/dashboard_repo.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  static const String _boxName = 'expenses';
  late Box<ExpenseModel> _expenseBox;

  DashboardRepositoryImpl() {
    _initBox();
  }

  Future<void> _initBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _expenseBox = await Hive.openBox<ExpenseModel>(_boxName);
    } else {
      _expenseBox = Hive.box<ExpenseModel>(_boxName);
    }
  }
////////////////////////////////////////////////////////////////////////////////
  @override
  Future<Either<Failure, List<ExpenseEntity>>> getAllExpenses({
    String? filterType,
    int? page,
    int? limit,
  }) async {
    try {
      await _initBox();

      List<ExpenseModel> expenses = _expenseBox.values.toList();
      print('ExpenseRepository: Total expenses in box: ${expenses.length}');

      // Apply filter if specified
      if (filterType != null) {
        print('ExpenseRepository: Applying filter: $filterType');
        expenses = _applyFilter(expenses, filterType);
        print('ExpenseRepository: Expenses after filter: ${expenses.length}');
      }

      // Sort by date (newest first)
      expenses.sort((a, b) => b.date.compareTo(a.date));

      // Apply pagination
<<<<<<< HEAD
      if (page == null || page < 1) page = 1;

      final startIndex = (page - 1) * limit!;
      if (startIndex >= expenses.length) {
        return Right([]);
      }

      final endIndex = (startIndex + limit).clamp(0, expenses.length);
      expenses = expenses.sublist(startIndex, endIndex);
=======
      // Pagination
      if (page != null && limit != null) {
        final startIndex = page * limit;
        if (startIndex >= expenses.length) {
          return const Right([]); // مفيش داتا تانية
        }
        final endIndex = (startIndex + limit).clamp(0, expenses.length);
        expenses = expenses.sublist(startIndex, endIndex);
      }

>>>>>>> 176486876e7b4bf114dfed15146c5c2be23792a4

      final entities = expenses.map((model) => model.toEntity()).toList();
      print('ExpenseRepository: Returning ${entities.length} expense entities');
      for (var entity in entities) {
        print('ExpenseRepository: Entity - ${entity.category}: ${entity.amount} ${entity.currency} on ${entity.date}');
      }

      return Right(entities);
    } catch (e) {
      print('ExpenseRepository: Error getting expenses: $e');
      return Left(Failure('Failed to get expenses: ${e.toString()}'));
    }
  }

////////////////////////////////////////////////////////////////////////////////
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
////////////////////////////////////////////////////////////////////////////////
  List<ExpenseModel> _applyFilter(
      List<ExpenseModel> expenses, String filterType) {
    final now = DateTime.now();
    print('ExpenseRepository: Filtering ${expenses.length} expenses with filter: $filterType');

    switch (filterType) {
      case 'This Month':
        final filtered = expenses.where((expense) {
          return expense.date.year == now.year &&
              expense.date.month == now.month;
        }).toList();
        print('ExpenseRepository: This Month filter returned ${filtered.length} expenses');
        return filtered;

      case 'Last 7 Days':
        final sevenDaysAgo = now.subtract(const Duration(days: 7));
        final filtered = expenses.where((expense) {
          return expense.date.isAfter(sevenDaysAgo);
        }).toList();
        print('ExpenseRepository: Last 7 Days filter returned ${filtered.length} expenses');
        return filtered;

      case 'Last 30 Days':
        final thirtyDaysAgo = now.subtract(const Duration(days: 30));
        final filtered = expenses.where((expense) {
          return expense.date.isAfter(thirtyDaysAgo);
        }).toList();
        print('ExpenseRepository: Last 30 Days filter returned ${filtered.length} expenses');
        return filtered;

      default:
        print('ExpenseRepository: No filter applied, returning all ${expenses.length} expenses');
        return expenses;
    }
  }
}
