import 'package:dio/dio.dart';
import 'package:inovola_task/core/services/dio.dart';
import 'package:inovola_task/features/add_expense/data/dataSource/remote/remote_dataSource.dart';

class GetCurrencyDatasource implements CurrencyRemoteDataSource{
  @override
  Future<Map<String, double>> getExchangeRates() async {
    final response = await DioHelper.getFromApi(url: "USD");
    if (response.statusCode == 200) {
      final data = response.data;
      if (data['rates'] != null) {
        return Map<String, double>.from(data['rates']);
      }
    }
    throw Exception('Failed to fetch exchange rates');
  }
}