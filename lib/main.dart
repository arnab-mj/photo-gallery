import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:photo_gallery/models/photos_list_response.dart';
import 'package:photo_gallery/utils/styles.dart';
import 'package:photo_gallery/views/gallery_screen/gallery_screen.dart';
import 'package:photo_gallery/views/photo_preview_screen/photo_preview_screen.dart';
import 'package:photo_gallery/views/splash_screen/splash_screen.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PhotoAdapter());
  
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
          GalleryScreen.routeName: (context) => const GalleryScreen(),
        },
        onGenerateRoute: (settings) {
        switch (settings.name) {
          case PhotoPreviewScreen.routeName:
            {
              final args = settings.arguments as PhotoPreviewScreenArgs;
              return MaterialPageRoute(
                builder: (context) {
                  return PhotoPreviewScreen(args: args);
                },
              );
            }
          default:
            {
              assert(false, 'Need to implement ${settings.name}');
              return null;
            }
        }
      },
    );
  }
}
