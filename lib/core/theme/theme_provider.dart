import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider() {
    _loadTheme();
  }

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  Color _primaryColor = const Color(0xFF00D4A3);
  Color get primaryColor => _primaryColor;

  void setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', mode.name);
  }

  void setPrimaryColor(Color color) async {
    _primaryColor = color;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('primary_color', color.value);
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load theme mode
    final themeName = prefs.getString('theme_mode') ?? ThemeMode.system.name;
    _themeMode = ThemeMode.values.firstWhere(
      (e) => e.name == themeName,
      orElse: () => ThemeMode.system,
    );

    // Load primary color
    final colorValue = prefs.getInt('primary_color');
    if (colorValue != null) {
      _primaryColor = Color(colorValue);
    }

    Future.microtask(() => notifyListeners());
  }
}
