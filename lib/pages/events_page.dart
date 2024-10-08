import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/events_provider.dart';

class EventsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EventProvider(), // Injecter le provider
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Evénements', style: TextStyle(color: Colors.white)),
            iconTheme: IconThemeData(
              color: Colors.white, // Couleur de la flèche de retour en blanc
            ),
            backgroundColor: Colors.blue,
            bottom: TabBar(
              indicatorColor: Colors.white,
              indicatorWeight: 4.0,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white54,
              labelStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold, // Style de texte pour l'onglet actif
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal, // Style de texte pour les onglets inactifs
              ),
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
                color: Colors.black.withOpacity(0.5),
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

  Widget buildEventList(List events, {bool isPast = false}) {
    if (events.isEmpty) {
      return Center(
        child: Text(
          isPast ? 'Aucun événement passé disponible.' : 'Aucun événement à venir.',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        var event = events[index];
        DateTime eventDate = DateTime.parse(event['date']);
        String day = eventDate.day.toString();
        String month = getAbbreviatedMonth(eventDate.month);
        String year = eventDate.year.toString();

        return eventCard(day, month, year, event['title'], event['time'], event['description']);
      },
    );
  }

  // Fonction pour obtenir le mois abrégé
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
                Text(month ?? 'N/A', style: TextStyle(color: Colors.white70, fontSize: 18)),
                Text(year ?? 'N/A', style: TextStyle(color: Colors.white70, fontSize: 18)),
              ],
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title ?? 'Titre inconnu', style: TextStyle(color: Colors.cyanAccent, fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text(description ?? 'Pas de description', style: TextStyle(color: Colors.white70)),
                  SizedBox(height: 4),
                  Text(time ?? 'Heure inconnue', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
