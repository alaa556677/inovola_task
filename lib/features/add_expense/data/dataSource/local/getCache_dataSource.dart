import 'dart:convert';
import 'package:inovola_task/core/utils/cache_helper.dart';
import '../../../../../core/utils/constants.dart';
import 'local_dataSource.dart';

class CurrencyLocalDataSourceImpl implements CurrencyLocalDataSource {
  static const String _cacheKey = 'currency_rates_cache';
  static const String _cacheTimestampKey = 'currency_rates_timestamp';
  static const Duration _cacheValidDuration = Duration(hours: 24);

  @override
  Future<Map<String, double>?> getCachedRates({bool ignoreExpiry = false}) async {
    final cachedData = CacheHelper.getData(key: Constants.cachedData.toString());
    final timestamp = CacheHelper.getData(key: Constants.cacheTimestampKey.toString());

    if (cachedData == null || timestamp == null) return null;

    if (!ignoreExpiry) {
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      if (DateTime.now().difference(cacheTime) > _cacheValidDuration) {
        return null; // expired
      }
    }

    final Map<String, dynamic> jsonData = json.decode(cachedData);
    return Map<String, double>.from(jsonData);
  }

  @override
  Future<void> cacheRates(Map<String, double> rates) async {
    CacheHelper.saveData(key: Constants.cachedData.toString(), value: json.encode(rates));
    CacheHelper.saveData(key: Constants.cacheTimestampKey.toString(), value: DateTime.now().millisecondsSinceEpoch);
  }
}