import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/restaurant_config.dart';

class RestaurantProvider extends ChangeNotifier {
  static const String _storageKey = 'nandi_restaurant_config_v1';
  RestaurantConfig _config = const RestaurantConfig();
  bool _isLoading = true;

  RestaurantConfig get config => _config;
  bool get isLoading => _isLoading;

  RestaurantProvider() {
    _loadFromPreferences();
  }

  Future<void> _loadFromPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedJson = prefs.getString(_storageKey);
      if (savedJson != null) {
        final map = jsonDecode(savedJson) as Map<String, dynamic>;
        _config = RestaurantConfig.fromJson(map);
      }
    } catch (e) {
      debugPrint('Error loading restaurant config: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateConfig(RestaurantConfig newConfig) async {
    _config = newConfig;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, jsonEncode(newConfig.toJson()));
    } catch (e) {
      debugPrint('Error saving restaurant config: $e');
    }
  }

  Future<void> resetToDefaults() async {
    _config = const RestaurantConfig();
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
    } catch (e) {
      debugPrint('Error resetting config: $e');
    }
  }
}
