import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static const String _cacheKeyPrefix = 'market_cache_';
  static const Duration _cacheDuration = Duration(hours: 1);

  Future<void> saveToCache(String key, List<dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheData = {
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'data': data,
    };
    await prefs.setString('$_cacheKeyPrefix$key', json.encode(cacheData));
  }

  Future<List<dynamic>?> getFromCache(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedString = prefs.getString('$_cacheKeyPrefix$key');
    if (cachedString != null) {
      final cachedData = json.decode(cachedString);
      final timestamp = DateTime.fromMillisecondsSinceEpoch(cachedData['timestamp']);
      if (DateTime.now().difference(timestamp) < _cacheDuration) {
        return cachedData['data'];
      }
    }
    return null;
  }
}