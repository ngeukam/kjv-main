import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class PhotoGalleryPage extends StatelessWidget {
  final List<String> photos = [
    'assets/blue-fond.jpg',
    'assets/logo.png',
    // Ajoutez d'autres images ici
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cartographies', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(
          color: Colors.white, // Couleur de la flèche de retour en blanc
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Deux colonnes
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: photos.length,
          itemBuilder: (context, index) {
            return PhotoItem(
              photoUrl: photos[index],
              index: index, // Ajouter l'index pour le Hero animation
            );
          },
        ),
      ),
    );
  }
}

class PhotoItem extends StatelessWidget {
  final String photoUrl;
  final int index; // L'index est nécessaire pour identifier chaque image dans Hero

  PhotoItem({required this.photoUrl, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Action lors du clic sur l'image
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhotoZoomPage(photoUrl: photoUrl, index: index),
          ),
        );
      },
      child: Hero(
        tag: 'photoHero-$index', // Tag unique pour l'animation Hero
        child: Card(
          elevation: 4,
          child: Stack(
            children: [
              Image.asset(
                photoUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(
                    Icons.share,
                    color: Colors.red[200],
                    size: 28,
                  ),
                  onPressed: () {
                    _sharePhoto(photoUrl);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fonction pour partager la photo
  void _sharePhoto(String url) {
    Share.share('Check out this cool photo: $url');
  }
}

// Page pour zoomer sur la photo
class PhotoZoomPage extends StatelessWidget {
  final String photoUrl;
  final int index;

  PhotoZoomPage({required this.photoUrl, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo en Grand'),
      ),
      body: Center(
        child: Hero(
          tag: 'photoHero-$index', // Doit correspondre au tag du Hero précédent
          child: Image.asset(
            photoUrl,
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}
