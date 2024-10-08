// custom_drawer.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/login_register.dart';

class CustomDrawer extends StatelessWidget {
  final LoginRegisterService apiService = LoginRegisterService();

  CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        width: 250, // Vous pouvez ajuster la largeur ici
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Menu Principal',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  /*IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop(); // Ferme le drawer
                    },
                  ),*/
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Nouveau testament'),
              onTap: () {
                Get.toNamed('/NewblsHomePage');
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Ancien testament'),
              onTap: () {
                Get.toNamed('/HomePage');
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text('Evénements'),
              onTap: () {
                Get.toNamed('/EventsPage');
              },
            ),
            ListTile(
              leading: const Icon(Icons.handshake),
              title: const Text('Prières'),
              onTap: () {
                Get.toNamed('/PrayersPage');
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Cartographies'),
              onTap: () {
                Get.toNamed('/PhotoGalleryPage');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Se déconnecter'),
              onTap: () async {
                await apiService.logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
