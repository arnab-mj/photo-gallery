import 'dart:async';

import 'package:flutter/material.dart';
import 'package:photo_gallery/utils/app_constant.dart';
import 'package:photo_gallery/views/gallery_screen/gallery_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      initializeApp();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppConstant.appBackground,
              fit: BoxFit.cover,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Photo Gallery',
                style: TextStyle(
                  fontFamily: 'Bellania',
                  color: Colors.white,
                  fontSize: 24.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void initializeApp() {
    Navigator.pushReplacementNamed(context, GalleryScreen.routeName);
  }
}
