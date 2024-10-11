import 'package:flutter/material.dart';
import 'package:BibleEngama/services/fetch_events.dart';
import '../models/event.dart'; // Importez le modèle

class EventProvider with ChangeNotifier {
  List<EventModel> _events = [];
  List<EventModel> _pastEvents = [];
  bool _loading = true;

  List<EventModel> get events => _events;
  List<EventModel> get pastEvents => _pastEvents;
  bool get loading => _loading;

  final FetchEvents _eventService = FetchEvents();

  EventProvider() {
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      List<dynamic> events = await _eventService.fetchEvents();

      DateTime now = DateTime.now();

      _events = events.map((event) => EventModel.fromJson(event))
          .where((event) => event.date.isAfter(now)) // Événements à venir
          .toList();

      _pastEvents = events.map((event) => EventModel.fromJson(event))
          .where((event) => event.date.isBefore(now)) // Événements passés
          .toList();

    } catch (e) {
      print(e.toString());
    } finally {
      _loading = false;
      notifyListeners(); // Notifie les widgets d'une mise à jour
    }
  }
}
