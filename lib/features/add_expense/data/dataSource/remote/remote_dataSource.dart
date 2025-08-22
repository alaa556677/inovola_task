abstract class CurrencyRemoteDataSource {
  Future<Map<String, double>> getExchangeRates();
}