import 'package:BibleEngama/pages/bibleoption_page.dart';
import 'package:flutter/material.dart';
import 'package:BibleEngama/pages/login_page.dart';
import 'package:BibleEngama/services/fetch_books.dart';
import 'package:BibleEngama/services/fetch_verses.dart';
import 'package:BibleEngama/services/save_current_index.dart';
import 'package:provider/provider.dart';
import 'models/verse.dart';
import 'providers/main_provider.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';  // Import shared_preferences

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => MainProvider())],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  Future<void> _initAsync() async {
    MainProvider mainProvider = Provider.of<MainProvider>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 100));

    await FetchVerses.execute(mainProvider: mainProvider);
    await FetchBooks.execute(mainProvider: mainProvider);

    mainProvider.itemPositionsListener.itemPositions.addListener(() {
      if (mainProvider.verses.isNotEmpty) {
        int index = mainProvider.itemPositionsListener.itemPositions.value.last.index;

        SaveCurrentIndex.execute(index: index);
        Verse currentVerse = mainProvider.verses[index];

        if (mainProvider.currentVerse == null) {
          mainProvider.updateCurrentVerse(verse: mainProvider.verses.first);
        }

        Verse previousVerse = mainProvider.currentVerse ?? mainProvider.verses.first;

        if (currentVerse.book != previousVerse.book) {
          mainProvider.updateCurrentVerse(verse: currentVerse);
        }
      }
    });

    await _checkLoginStatus();
    setState(() {
      _loading = false;
    });
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();  // Get SharedPreferences instance
    final token = prefs.getString('token') ?? '';  // Retrieve token
    await Future.delayed(const Duration(milliseconds: 100));
    if (token.isNotEmpty && _isTokenValid(token)) {
      Get.offAll(() => BibleOptionsPage());
    } else {
      Get.offAll(() => LoginPage());
    }
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
      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorSchemeSeed: Colors.red[200],
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.red[200],
        brightness: Brightness.light,
      ),
      home: _loading
          ? const Center(child: CircularProgressIndicator(strokeCap: StrokeCap.round))
          : const SizedBox.shrink(),
    );
  }
}
