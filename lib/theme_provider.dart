import 'package:flutter/material.dart';
import 'package:ai_interact/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;
  String theme = "light";
  ThemeData get themeData => _themeData;
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() async {
    if (_themeData == lightMode) {
      themeData = darkMode;
      theme = "dark";
    } else {
      themeData = lightMode;
      theme = "light";
    }
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString("theme", theme);
  }

  void initializeTheme() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    theme = _prefs.getString("theme") ?? "light";
    if (theme == "light") {
      themeData = lightMode;
    } else {
      themeData = darkMode;
    }
  }
}
