import 'package:flutter/material.dart';
import 'package:flutter_node_store/utils/utility.dart';

class ThemeProvider extends ChangeNotifier {

  ThemeData _themeData;

  // status
  bool _isDark = false;

  // getter
  bool get isDark => _isDark;
  getTheme() => _themeData;

  // Constructor
  ThemeProvider(
    this._themeData,
    this._isDark,
  );

  // Set Theme
  setTheme(ThemeData themeData) async {
    _isDark = !_isDark;
    _themeData = themeData;

    // Save theme to SharedPreference
    Utility.setSharedPreference('isDark', _isDark);

    notifyListeners();
  }

}