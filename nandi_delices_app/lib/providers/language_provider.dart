import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage {
  fr,
  en,
}

class LanguageProvider extends ChangeNotifier {
  static const String _storageKey = 'nandi_app_language_v1';
  AppLanguage _currentLanguage = AppLanguage.fr;

  AppLanguage get currentLanguage => _currentLanguage;
  bool get isFrench => _currentLanguage == AppLanguage.fr;
  bool get isEnglish => _currentLanguage == AppLanguage.en;

  LanguageProvider() {
    _loadLanguagePreference();
  }

  Future<void> _loadLanguagePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final code = prefs.getString(_storageKey);
      if (code == 'en') {
        _currentLanguage = AppLanguage.en;
        notifyListeners();
      } else if (code == 'fr') {
        _currentLanguage = AppLanguage.fr;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading language: $e');
    }
  }

  Future<void> setLanguage(AppLanguage language) async {
    if (_currentLanguage == language) return;
    _currentLanguage = language;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, language == AppLanguage.fr ? 'fr' : 'en');
    } catch (e) {
      debugPrint('Error saving language: $e');
    }
  }

  Future<void> toggleLanguage() async {
    await setLanguage(isFrench ? AppLanguage.en : AppLanguage.fr);
  }

  String tr({required String fr, required String en}) {
    return isFrench ? fr : en;
  }
}
