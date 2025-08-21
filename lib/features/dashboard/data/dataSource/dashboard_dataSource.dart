import 'package:dio/dio.dart';
import '../models/get_expense_model.dart';

abstract class DashboardDataSource{
  Future<List<GetExpenseModel>> getAllExpenses(CancelToken? cancelToken);
}
