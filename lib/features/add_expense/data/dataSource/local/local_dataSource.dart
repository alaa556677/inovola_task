abstract class CurrencyLocalDataSource {
  Future<Map<String, double>?> getCachedRates({bool ignoreExpiry = false});
  Future<void> cacheRates(Map<String, double> rates);
}