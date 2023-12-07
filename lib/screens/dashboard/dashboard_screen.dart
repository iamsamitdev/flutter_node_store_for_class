// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_node_store/app_router.dart';
import 'package:flutter_node_store/providers/theme_provider.dart';
import 'package:flutter_node_store/screens/bottomnavpage/home_screen.dart';
import 'package:flutter_node_store/screens/bottomnavpage/notification_screen.dart';
import 'package:flutter_node_store/screens/bottomnavpage/profile_screen.dart';
import 'package:flutter_node_store/screens/bottomnavpage/report_screen.dart';
import 'package:flutter_node_store/screens/bottomnavpage/setting_screen.dart';
import 'package:flutter_node_store/themes/colors.dart';
import 'package:flutter_node_store/utils/utility.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // ส่วนของการสร้าง Bottom Navigation Bar ---------------------------------
  // สร้างตัวแปรเก็บ title ของแต่ละหน้า
  String _title = 'Flutter Store';

  // สร้างตัวแปรเก็บ index ของแต่ละหน้า
  int _currentIndex = 0;

  // สร้าง List ของแต่ละหน้า
  final List<Widget> _children = [
    HomeScreen(),
    ReportScreen(),
    NotificationScreen(),
    SettingScreen(),
    ProfileScreen()
  ];

  // ฟังก์ขันในการเปลี่ยนหน้า โดยรับค่า index จากการกดที่ bottomNavigationBar
  void onTabTapped(int index) {
    setState(
      () {
        _currentIndex = index;
        switch (index) {
          case 0:
            _title = AppLocalizations.of(context)!.menu_home;
            break;
          case 1:
            _title = AppLocalizations.of(context)!.menu_report;
            break;
          case 2:
            _title = AppLocalizations.of(context)!.menu_notification;
            break;
          case 3:
            _title = AppLocalizations.of(context)!.menu_setting;
            break;
          case 4:
            _title = AppLocalizations.of(context)!.menu_profile;
            break;
          default:
            _title = 'Flutter Store';
        }
      },
    );
  }
  // ---------------------------------------------------------------------------

  // Logout function -----------------------------------------------------------
  _logout() {
    // Remove token, loginStatus shared preference
    Utility.removeSharedPreference('token');
    Utility.removeSharedPreference('loginStatus');

    // Clear all route and push to login screen
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRouter.login,
      (route) => false,
    );
  }
  // ---------------------------------------------------------------------------


  // สร้างตัวแปรไว้เก็บค่า user profile
  String? _fistname, _lastname, _email;

  // Get User Profile
  getUserProfile() async {
    var firstName = await Utility.getSharedPreference('firstName');
    var lastName = await Utility.getSharedPreference('lastName');
    var email = await Utility.getSharedPreference('email');

    setState(() {
      _fistname = firstName;
      _lastname = lastName;
      _email = email;
    });

    // print('firstName: $_fistname');
    // print('lastName: $_lastname');
    // print('email: $_email');
  }

  @override
  void initState() {
    super.initState();
    getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            ListView(
              shrinkWrap: true,
              children: [
                Consumer<ThemeProvider>(
                  builder: (context, provider, child){
                  return UserAccountsDrawerHeader(
                    margin: EdgeInsets.only(bottom: 0.0),
                    accountName: Text('$_fistname $_lastname'),
                    accountEmail: Text('$_email'),
                    decoration: BoxDecoration(
                      color: provider.isDark ? primaryText : primary,
                    ),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/noavartar.png'),
                    ),
                    otherAccountsPictures: [
                      CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/images/noavartar.png'),
                      ),
                    ],
                  );
                  }
                ),
                ListTile(
                  leading: Icon(
                    Icons.timer,
                    color: icons,
                  ),
                  title: Text('Counter (With Statefull)',
                      style: TextStyle(
                        color: icons,
                      )),
                  onTap: () {
                    Navigator.pushNamed(context, AppRouter.counterStateful);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.timer,
                    color: icons,
                  ),
                  title: Text('Counter (With Provider)',
                      style: TextStyle(
                        color: icons,
                      )),
                  onTap: () {
                    Navigator.pushNamed(context, AppRouter.counterProvider);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.info_outline,
                    color: icons,
                  ),
                  title: Text(AppLocalizations.of(context)!.menu_info,
                      style: TextStyle(
                        color: icons,
                      )),
                  onTap: () {
                    Navigator.pushNamed(context, AppRouter.info);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.person_outline,
                    color: icons,
                  ),
                  title: Text(AppLocalizations.of(context)!.menu_about,
                      style: TextStyle(
                        color: icons,
                      )),
                  onTap: () {
                    Navigator.pushNamed(context, AppRouter.about);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.email_outlined,
                    color: icons,
                  ),
                  title: Text(AppLocalizations.of(context)!.menu_contact,
                      style: TextStyle(
                        color: icons,
                      )),
                  onTap: () {
                    Navigator.pushNamed(context, AppRouter.contact);
                  },
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.exit_to_app_outlined,
                      color: icons,
                    ),
                    title: Text(AppLocalizations.of(context)!.menu_logout,
                        style: TextStyle(
                          color: icons,
                        )),
                    onTap: _logout,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // endDrawer: Drawer(),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          onTabTapped(value);
        },
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryDark,
        unselectedItemColor: secondaryText,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: AppLocalizations.of(context)!.menu_home),
          BottomNavigationBarItem(
              icon: Icon(Icons.show_chart_outlined),
              label: AppLocalizations.of(context)!.menu_report),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_outlined),
              label: AppLocalizations.of(context)!.menu_notification),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: AppLocalizations.of(context)!.menu_setting),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: AppLocalizations.of(context)!.menu_profile),
        ],
      ),
    );
  }
}
