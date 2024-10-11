import 'package:BibleEngama/pages/form_page.dart';
import 'package:BibleEngama/providers/events_provider.dart';
import 'package:BibleEngama/providers/form_provider.dart';
import 'package:BibleEngama/providers/main_provider.dart';
import 'package:BibleEngama/providers/newbls_main_provider.dart';
import 'package:BibleEngama/providers/prayers_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'pages/events_page.dart';
import 'pages/gallery.dart';
import 'pages/home_page.dart';
import 'pages/newbls_home_page.dart';
import 'pages/prayer_page.dart';
import 'pages/register_page.dart';
import 'pages/bibleoption_page.dart';
import 'pages/login_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MainProvider()),
        ChangeNotifierProvider(create: (context) => NewBlsMainProvider()),
        ChangeNotifierProvider(create: (context) => EventProvider()),
        ChangeNotifierProvider(create: (context) => PrayerProvider()),
        ChangeNotifierProvider(create: (context) => FormProvider()),// Add other providers here
        // Add more providers as needed
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool _loading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus().then((isLoggedIn) {
      setState(() {
        _loading = false;
        _isLoggedIn = isLoggedIn;
      });
    });
  }

  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? ''; // Retrieve token
    //return token != null && token.isNotEmpty && _isTokenValid(token);
    return token.isNotEmpty && _isTokenValid(token);
  }

  bool _isTokenValid(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return false;

    final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    final Map<String, dynamic> payloadMap = jsonDecode(payload);

    final exp = payloadMap['exp'];
    if (exp != null) {
      final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      return expiryDate.isAfter(DateTime.now());
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: _getPages(),
      themeMode: ThemeMode.system,
      theme: _buildThemeData(),
      darkTheme: _buildThemeData(),
      home: _loading
          ? const Center(child: CircularProgressIndicator())
          : _isLoggedIn
          ? BibleOptionsPage() // Redirection si connecté
          : LoginPage(), // Redirection si non connecté
    );
  }

  List<GetPage> _getPages() {
    return [
      GetPage(name: '/BibleOptionsPage', page: () => BibleOptionsPage()),
      GetPage(name: '/HomePage', page: () => HomePage()),
      GetPage(name: '/NewblsHomePage', page: () => NewblsHomePage()),
      GetPage(name: '/PrayersPage', page: () => PrayersPage()),
      GetPage(name: '/EventsPage', page: () => EventsPage()),
      GetPage(name: '/PhotoGalleryPage', page: () => PhotoGalleryPage()),
      GetPage(name: '/TopicPage', page: () => FormPage()),
      GetPage(name: '/LoginPage', page: () => LoginPage()),
      GetPage(name: '/RegisterPage', page: () => RegisterPage()),
    ];
  }

  ThemeData _buildThemeData() {
    return ThemeData(
      colorSchemeSeed: Colors.white,
      brightness: Brightness.light,
    );
  }
}
