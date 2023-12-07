// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_node_store/app_router.dart';
import 'package:flutter_node_store/providers/counter_provider.dart';
import 'package:flutter_node_store/providers/locale_provider.dart';
import 'package:flutter_node_store/providers/theme_provider.dart';
import 'package:flutter_node_store/providers/timer_provider.dart';
import 'package:flutter_node_store/themes/styles.dart';
import 'package:flutter_node_store/utils/utility.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// กำหนดตัวแปร initialRoute ให้กับ MaterialApp
var initialRoute;

// กำหนดตัวแปร locale, themeData, isDark ให้กับ Provider
var locale;
ThemeData? themeData;
var isDark;

void main() async {
  // Test Logger
  // Utility().testLogger();

  // ต้องเรียกใช้ WidgetsFlutterBinding.ensureInitialized()
  // เพื่อให้สามารถเรียกใช้ SharedPreferences ได้
  WidgetsFlutterBinding.ensureInitialized();

  // เรียกใช้ SharedPreferences
  await Utility.initSharedPrefs();

  // ถ้าเคย Login แล้ว ให้ไปยังหน้า Dashboard
  if (Utility.getSharedPreference('loginStatus') == true) {
    initialRoute = AppRouter.dashboard;
  } else if (Utility.getSharedPreference('welcomeStatus') == true) {
    // ถ้าเคยแสดง Intro แล้ว ให้ไปยังหน้า Login
    initialRoute = AppRouter.login;
  } else {
    // ถ้ายังไม่เคยแสดง Intro ให้ไปยังหน้า Welcome
    initialRoute = AppRouter.welcome;
  }

  // Set default locale from SharedPreference
  String? languageCode = Utility.getSharedPreference('languageCode');
  locale = Locale(languageCode ?? 'en');

  // Set default theme from SharedPreference
  isDark = Utility.getSharedPreference('isDark') ?? false;
  themeData = isDark == true && isDark != null ? AppTheme.darkTheme : AppTheme.lightTheme;

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CounterProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => TimerProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocaleProvider(locale),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(
            themeData!, isDark!
          ),
        ),
      ],
      child: Consumer2<LocaleProvider, ThemeProvider>(
        builder: (context, locale, theme, child){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: theme.getTheme(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: locale.locale,
            initialRoute: initialRoute,
            routes: AppRouter.routes,
          );
        },
      ),
    );
  }
}