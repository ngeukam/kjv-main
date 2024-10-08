import 'package:flutter/material.dart';
import '../services/fetch_prayers.dart';

class PrayerProvider with ChangeNotifier {
  List _prayers = [];
  bool _loading = true;

  List get prayers => _prayers;
  bool get loading => _loading;

  final FetchPrayers _prayerService = FetchPrayers();

  PrayerProvider() {
    fetchPrayers();
  }

  Future<void> fetchPrayers() async {
    try {
      _prayers = await _prayerService.fetchPrayers();
    } catch (e) {
      print(e);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
