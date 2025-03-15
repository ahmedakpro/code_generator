import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dark_theme.dart';
import 'light_theme.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeData _selectedTheme;
  SharedPreferences? prefs;

  ThemeProvider() {
    _selectedTheme = lightTheme; // Default theme
    _loadFromPrefs();
  }

  ThemeData get getTheme => _selectedTheme;

  Future<void> _loadFromPrefs() async {
    try {
      prefs = await SharedPreferences.getInstance();
      bool isDark = prefs?.getBool("isDark") ?? false;
      _selectedTheme = isDark ? darkTheme : lightTheme;
    } catch (e) {
      print("Error loading SharedPreferences: $e");
      _selectedTheme = lightTheme; // Fallback
    }
    notifyListeners();
  }

  Future<void> changeTheme() async {
    if (_selectedTheme == darkTheme) {
      _selectedTheme = lightTheme;
      await prefs?.setBool("isDark", false);
    } else {
      _selectedTheme = darkTheme;
      await prefs?.setBool("isDark", true);
    }
    notifyListeners();
  }
}
