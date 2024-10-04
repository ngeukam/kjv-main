import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'home_page.dart';

class BibleOptionsPage extends StatelessWidget {
  const BibleOptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand, // Prend tout l'espace disponible
        children: [
          // Arrière-plan
          Image.asset(
            'assets/blue-fond.jpg', // Assure-toi que cette image existe dans tes assets
            fit: BoxFit.cover,
          ),
          // Superposition semi-transparente
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          // Contenu avec scroll si nécessaire
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  // Ajoute un espacement pour le titre
                  const SizedBox(height: 150), // Ajuste cette valeur pour déplacer le titre plus bas
                  // Titre
                  Text(
                    'Bible Louis Second 1910 pro',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Grille de boutons dans Expanded
                  GridView.count(
                    shrinkWrap: true, // Permet au GridView de s'adapter à son contenu
                    physics: NeverScrollableScrollPhysics(), // Désactive le scroll interne pour laisser le SingleChildScrollView gérer
                    crossAxisCount: 3, // Nombre de colonnes
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      _buildGridButton(
                        icon: FontAwesomeIcons.list,
                        label: 'Guide thématique',
                        onPressed: () {
                          // Logique pour Sommaire
                        },
                      ),
                      _buildGridButton(
                        icon: FontAwesomeIcons.bookBible,
                        label: 'Ancien testament',
                        onPressed: () {
                          // Navigation vers HomePage
                          Get.to(() => HomePage(),
                            transition: Transition.leftToRight,
                          );
                        },
                      ),
                      _buildGridButton(
                        icon: FontAwesomeIcons.bookBible,
                        label: 'Nouveau testament',
                        onPressed: () {
                          // Logique pour Nouveau testament
                        },
                      ),
                      _buildGridButton(
                        icon: FontAwesomeIcons.image,
                        label: 'Cartographies',
                        onPressed: () {
                          // Logique pour Biotope
                        },
                      ),
                      _buildGridButton(
                        icon: FontAwesomeIcons.video,
                        label: 'Vidéos',
                        onPressed: () {
                          // Logique pour Vidéos
                        },
                      ),
                      _buildGridButton(
                        icon: FontAwesomeIcons.handsPraying,
                        label: 'Prières',
                        onPressed: () {
                          // Logique pour Prières
                        },
                      ),
                      _buildGridButton(
                        icon: FontAwesomeIcons.calendar,
                        label: 'Evénements',
                        onPressed: () {
                          // Logique pour Evénements
                        },
                      ),
                      _buildGridButton(
                        icon: FontAwesomeIcons.clock,
                        label: 'Heures de prières',
                        onPressed: () {
                          // Logique pour Heures de prières
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fonction pour construire un bouton de grille
  Widget _buildGridButton({required IconData icon, required String label, required Function() onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.withOpacity(0.5),
        padding: const EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.red[200]),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
