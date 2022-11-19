import 'package:flutter/material.dart';

void main() {
  runApp(const PhotoGallery());
}

class PhotoGallery extends StatelessWidget {
  const PhotoGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Photo Gallery',
      home: Scaffold(),
    );
  }
}
