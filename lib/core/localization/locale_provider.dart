import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  LocaleProvider() {
    _loadLocale();
  }

  Locale _locale = const Locale('es');
  Locale get locale => _locale;

  void setLocale(Locale locale) async {
    if (!['en', 'es'].contains(locale.languageCode)) return;
    _locale = locale;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
  }

  void _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'es';
    _locale = Locale(languageCode);
    Future.microtask(() => notifyListeners());
  }
}
