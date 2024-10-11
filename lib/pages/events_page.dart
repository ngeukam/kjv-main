import 'package:BibleEngama/utils/auth_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../providers/events_provider.dart';
import '../models/event.dart'; // Importez le modèle

class EventsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _checkLogin(context); // Vérification de connexion
    return ChangeNotifierProvider(
      create: (_) => EventProvider(), // Injecter le provider
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Événements', style: TextStyle(color: Colors.white)),
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.blue,
            bottom: TabBar(
              indicatorColor: Colors.white,
              indicatorWeight: 4.0,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white54,
              labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              unselectedLabelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
              tabs: [
                Tab(text: 'À venir'),
                Tab(text: 'Passés'),
              ],
            ),
          ),
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/blue-fond.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                color: Colors.lightBlue.withOpacity(0.5),
              ),
              Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: 600),
                  child: Consumer<EventProvider>(
                    builder: (context, provider, child) {
                      if (provider.loading) {
                        return Center(child: CircularProgressIndicator());
                      }

                      return TabBarView(
                        children: [
                          buildEventList(provider.events),
                          buildEventList(provider.pastEvents, isPast: true),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEventList(List<EventModel> events, {bool isPast = false}) {
    if (events.isEmpty) {
      return Center(
        child: Text(
          isPast ? 'Aucun événement passé disponible.' : 'Aucun événement à venir.',
          style: TextStyle(color: Colors.white, fontSize: 18, decoration: TextDecoration.none),
        ),
      );
    }

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        var event = events[index];

        String day = event.date.day.toString();
        String month = getAbbreviatedMonth(event.date.month);
        String year = event.date.year.toString();

        return eventCard(day, month, year, event.title, event.time, event.description);
      },
    );
  }

  String getAbbreviatedMonth(int month) {
    const monthNames = [
      "Jan", "Feb", "Mar", "Avr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Déc"
    ];
    return monthNames[month - 1];
  }

  Widget eventCard(String? day, String? month, String? year, String? title, String? time, String? description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Column(
              children: [
                Text(day ?? 'N/A', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                Text(month ?? 'N/A', style: TextStyle(color: Colors.white, fontSize: 18)),
                Text(year ?? 'N/A', style: TextStyle(color: Colors.white, fontSize: 18)),
              ],
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title ?? 'Titre inconnu', style: TextStyle(color: Colors.cyanAccent, fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text(description ?? 'Pas de description', style: TextStyle(color: Colors.white)),
                  SizedBox(height: 4),
                  Text(time ?? 'Heure inconnue', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _checkLogin(BuildContext context) async {
    final isLoggedIn = await AuthHelper.checkLoginStatus();
    if (!isLoggedIn) {
      Get.offAllNamed('/LoginPage'); // Redirige vers la page de connexion
    }
  }
}
