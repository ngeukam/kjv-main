import 'package:flutter/material.dart';
import '../services/fetch_prayers.dart';
import 'package:BibleEngama/models/prayer.dart'; // Importez le modèle

class PrayerProvider with ChangeNotifier {
  List<PrayerModel> _prayers = [];
  bool _loading = true;

  List<PrayerModel> get prayers => _prayers;
  bool get loading => _loading;

  final FetchPrayers _prayerService = FetchPrayers();

  PrayerProvider() {
    fetchPrayers();
  }

  Future<void> fetchPrayers() async {
    try {
      final List<dynamic> jsonPrayers = await _prayerService.fetchPrayers();
      _prayers = jsonPrayers.map((json) => PrayerModel.fromJson(json)).toList();
    } catch (e) {
      print(e);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
