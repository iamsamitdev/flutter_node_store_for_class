import 'package:flutter/material.dart';
import 'package:flutter_node_store/utils/utility.dart';

class LocaleProvider extends ChangeNotifier {

  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  // Constructor
  LocaleProvider(Locale locale) {
    _locale = locale;
  }

  // Change Locale
  void changeLocale(Locale newLocale) async {

    // Save Locale to Shared Preferences
    await Utility.setSharedPreference('languageCode', newLocale.languageCode);

    _locale = newLocale;
    notifyListeners();
  }

}