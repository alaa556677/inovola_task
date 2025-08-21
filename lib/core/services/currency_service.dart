import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyService {
  static const String _baseUrl = 'https://open.er-api.com/v6/latest/USD';
  static const String _cacheKey = 'currency_rates_cache';
  static const String _cacheTimestampKey = 'currency_rates_timestamp';
  static const Duration _cacheValidDuration = Duration(hours: 24);

  final Dio _dio;

  CurrencyService(this._dio);

  /// Get current exchange rates from API or cache
  Future<Map<String, double>> getExchangeRates() async {
    try {
      // Check cache first
      final cachedRates = await _getCachedRates();
      if (cachedRates != null) {
        return cachedRates;
      }

      // Fetch from API
      final response = await _dio.get(_baseUrl);
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['rates'] != null) {
          final rates = Map<String, double>.from(data['rates']);

          // Cache the rates
          await _cacheRates(rates);

          return rates;
        }
      }

      throw Exception('Failed to fetch exchange rates');
    } catch (e) {
      // Return cached rates if available, even if expired
      final cachedRates = await _getCachedRates(ignoreExpiry: true);
      if (cachedRates != null) {
        return cachedRates;
      }

      // Return default rates if no cache available
      return _getDefaultRates();
    }
  }

  /// Convert amount from one currency to USD
  Future<double> convertToUSD(double amount, String fromCurrency) async {
    if (fromCurrency == 'USD') return amount;

    final rates = await getExchangeRates();
    final rate = rates[fromCurrency];

    if (rate == null) {
      throw Exception('Exchange rate not available for $fromCurrency');
    }

    return amount / rate;
  }

  /// Convert amount from USD to another currency
  Future<double> convertFromUSD(double amount, String toCurrency) async {
    if (toCurrency == 'USD') return amount;

    final rates = await getExchangeRates();
    final rate = rates[toCurrency];

    if (rate == null) {
      throw Exception('Exchange rate not available for $toCurrency');
    }

    return amount * rate;
  }

  /// Get cached exchange rates
  Future<Map<String, double>?> _getCachedRates(
      {bool ignoreExpiry = false}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(_cacheKey);
      final timestamp = prefs.getInt(_cacheTimestampKey);

      if (cachedData == null || timestamp == null) return null;

      if (!ignoreExpiry) {
        final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
        if (DateTime.now().difference(cacheTime) > _cacheValidDuration) {
          return null; // Cache expired
        }
      }

      final Map<String, dynamic> jsonData = json.decode(cachedData);
      return Map<String, double>.from(jsonData);
    } catch (e) {
      return null;
    }
  }

  /// Cache exchange rates
  Future<void> _cacheRates(Map<String, double> rates) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cacheKey, json.encode(rates));
      await prefs.setInt(
          _cacheTimestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      // Ignore cache errors
    }
  }

  /// Get default exchange rates for offline use
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
