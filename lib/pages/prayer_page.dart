import 'package:BibleEngama/utils/auth_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../providers/prayers_provider.dart';
import '../models/prayer.dart'; // Assurez-vous d'importer le modèle

class PrayersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _checkLogin(context);
    return ChangeNotifierProvider(
      create: (_) => PrayerProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Prières', style: TextStyle(color: Colors.white)),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.blue,
        ),
        body: Stack(
          children: [
            // Image d'arrière-plan
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/blue-fond.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Couche semi-transparente
            Container(
              color: Colors.lightBlue.withOpacity(0.5),
            ),
            // Contenu principal avec une largeur limitée
            Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 600),
                child: Consumer<PrayerProvider>(
                  builder: (context, provider, child) {
                    if (provider.loading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    // Vérifie si la liste des prières est vide
                    if (provider.prayers.isEmpty) {
                      return Center(
                        child: Text(
                          'Aucune prière disponible',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: provider.prayers.length,
                      itemBuilder: (context, index) {
                        var prayer = provider.prayers[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PrayerDetailPage(prayer: prayer),
                                ),
                              );
                            },
                            child: prayerCard(title: prayer.title),
                          ),
                        );
                      },
                    );
                  },
                ),
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

  Widget prayerCard({required String title}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PrayerDetailPage extends StatelessWidget {
  final PrayerModel prayer; // Changez Map en PrayerModel

  PrayerDetailPage({required this.prayer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(prayer.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              prayer.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              prayer.description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Auteur: ${prayer.author ?? 'Auteur non disponible'}',
              style: TextStyle(fontSize: 12,),
            ),
          ],
        ),
      ),
    );
  }
}
