import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:inovola_task/core/failure/failure.dart';
import 'package:inovola_task/features/add_expense/domain/entities/expense_entity.dart';
import '../../domain/repo/addExpense_repo.dart';
import '../dataSource/local/local_dataSource.dart';
import '../dataSource/remote/remote_dataSource.dart';
import '../models/expense_model.dart';

class AddExpenseRepoImpl implements AddExpenseRepository {
  static const String _boxName = 'expenses';
  late Box<ExpenseModel> _expenseBox;
  final CurrencyRemoteDataSource remoteDataSource;
  final CurrencyLocalDataSource localDataSource;
  AddExpenseRepoImpl(
    this.localDataSource,
    this.remoteDataSource
  ){
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
////////////////////////////////////////////////////////////////////////////////
  @override
  Future<double> convertToUSD(double amount, String fromCurrency) async {
    if (fromCurrency == 'USD') return amount;
    final rates = await getExchangeRates();
    final rate = rates[fromCurrency];
    if (rate == null) throw Exception('Exchange rate not available for $fromCurrency');
    return amount / rate;
  }
////////////////////////////////////////////////////////////////////////////////
  @override
  Future<double> convertFromUSD(double amount, String toCurrency) async {
    if (toCurrency == 'USD') return amount;
    final rates = await getExchangeRates();
    final rate = rates[toCurrency];
    if (rate == null) throw Exception('Exchange rate not available for $toCurrency');
    return amount * rate;
  }
////////////////////////////////////////////////////////////////////////////////
  @override
  Future<Map<String, double>> getExchangeRates() async {
    try {
      final cachedRates = await localDataSource.getCachedRates();
      if (cachedRates != null) return cachedRates;

      final remoteRates = await remoteDataSource.getExchangeRates();
      await localDataSource.cacheRates(remoteRates);
      return remoteRates;
    } catch (_) {
      final cachedRates = await localDataSource.getCachedRates(ignoreExpiry: true);
      if (cachedRates != null) return cachedRates;

      return _getDefaultRates();
    }
  }
////////////////////////////////////////////////////////////////////////////////
  Map<String, double> _getDefaultRates() {
    return {
      'USD': 1.0,
      'EUR': 0.85,
      'GBP': 0.73,
      'JPY': 110.0,
      'CAD': 1.25,
      'AUD': 1.35,
      'CHF': 0.92,
      'CNY': 6.45,
      'INR': 74.0,
      'BRL': 5.2,
    };
  }

}