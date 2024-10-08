// custom_fab.dart
import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return FloatingActionButton(
          onPressed: () {
            Scaffold.of(context).openDrawer(); // Ouvre le Drawer
          },
          backgroundColor: Colors.red[200],
          child: const Icon(Icons.menu, color: Colors.white), // Icône hamburger
        );
      },
    );
  }
}
