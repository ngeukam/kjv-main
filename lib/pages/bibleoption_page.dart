import 'package:BibleEngama/pages/gallery.dart';
import 'package:BibleEngama/pages/newbls_home_page.dart';
import 'package:BibleEngama/pages/prayer_page.dart';
import 'package:BibleEngama/utils/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../services/login_register.dart';
import 'home_page.dart';
import 'events_page.dart';

class BibleOptionsPage extends StatelessWidget {
  BibleOptionsPage({super.key});
  final LoginRegisterService apiService = LoginRegisterService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/blue-fond.jpg',
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 150),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Bible Louis Second 1910 pro',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      _buildGridButton(
                        icon: FontAwesomeIcons.list,
                        label: 'Guide thématique',
                        onPressed: () {},
                      ),
                      _buildGridButton(
                        icon: FontAwesomeIcons.bookBible,
                        label: 'Ancien testament',
                        onPressed: () {
                          Get.to(() => HomePage(), transition: Transition.leftToRight);
                        },
                      ),
                      _buildGridButton(
                        icon: FontAwesomeIcons.bookBible,
                        label: 'Nouveau testament',
                        onPressed: () {
                          Get.to(() => NewblsHomePage(), transition: Transition.leftToRight);
                        },
                      ),
                      _buildGridButton(
                        icon: FontAwesomeIcons.image,
                        label: 'Cartographies',
                        onPressed: () {
                          Get.to(() => PhotoGalleryPage(), transition: Transition.leftToRight);
                        },
                      ),
                      _buildGridButton(
                        icon: FontAwesomeIcons.handsPraying,
                        label: 'Prières',
                        onPressed: () {
                          Get.to(() => PrayersPage(), transition: Transition.leftToRight);
                        },
                      ),
                      _buildGridButton(
                        icon: FontAwesomeIcons.calendar,
                        label: 'Evénements',
                        onPressed: () {
                          Get.to(() => EventsPage(), transition: Transition.leftToRight);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: Icon(Icons.language, color: Colors.white, size: 30),
              onPressed: () async {
                // Call your logout method here
              },
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: Icon(Icons.menu, color: Colors.white, size: 30),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

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