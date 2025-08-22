import 'package:dio/dio.dart';
import 'package:inovola_task/features/add_expense/data/dataSource/remote/remote_dataSource.dart';

class GetCurrencyDatasource implements CurrencyRemoteDataSource{
  final Dio dio;
  static const String _baseUrl = 'https://open.er-api.com/v6/latest/USD';
  GetCurrencyDatasource(this.dio);

  @override
  Future<Map<String, double>> getExchangeRates() async {
    final response = await dio.get(_baseUrl);
    if (response.statusCode == 200) {
      final data = response.data;
      if (data['rates'] != null) {
        return Map<String, double>.from(data['rates']);
      }
    }
    throw Exception('Failed to fetch exchange rates');
  }
}