import 'package:flutter/material.dart';
import 'package:photo_gallery/utils/styles.dart';
import 'package:photo_gallery/views/splash_screen/splash_screen.dart';

void main() {
  runApp(const PhotoGallery());
}

class PhotoGallery extends StatelessWidget {
  const PhotoGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Gallery',
      theme: Styles.darkTheme(),
      routes: {
        '/': (context) => const SplashScreen(),
      },
    );
  }
}
