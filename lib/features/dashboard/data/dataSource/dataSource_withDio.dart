import 'package:dio/dio.dart';
import 'package:inovola_task/features/dashboard/data/dataSource/dashboard_dataSource.dart';
import '../../../../core/services/dio.dart';
import '../models/get_expense_model.dart';

class DashboardDataSourceWithDio implements DashboardDataSource{
  @override
  Future<List<GetExpenseModel>> getAllExpenses(CancelToken? cancelToken) async {
    final result = await DioHelper.getFromApi(
      url: "posts",
      cancelToken: cancelToken
    );
    // return CreateAppWIshModel.fromJson(result.data);
    final data = result.data;
    if (data is List) {
      return data.map((e) => GetExpenseModel.fromJson(e)).toList();
    } else {
      throw Exception("Unexpected response format: $data");
    }
  }
}

