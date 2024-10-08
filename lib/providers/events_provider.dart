import 'package:BibleEngama/services/fetch_events.dart';
import 'package:flutter/material.dart';

class EventProvider with ChangeNotifier {
  List _events = [];
  List _pastEvents = [];
  bool _loading = true;

  List get events => _events;
  List get pastEvents => _pastEvents;
  bool get loading => _loading;

  FetchEvents _eventService = FetchEvents();

  EventProvider() {
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      List events = await _eventService.fetchEvents();
      DateTime now = DateTime.now();

      _events = events.where((event) {
        DateTime eventDate = DateTime.parse(event['date']);
        return eventDate.isAfter(now); // Événements à venir
      }).toList();

      _pastEvents = events.where((event) {
        DateTime eventDate = DateTime.parse(event['date']);
        return eventDate.isBefore(now); // Événements passés
      }).toList();

    } catch (e) {
      print(e.toString());
    } finally {
      _loading = false;
      notifyListeners(); // Notifie les widgets d'une mise à jour
    }
  }
}