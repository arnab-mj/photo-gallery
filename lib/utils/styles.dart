import 'package:flutter/material.dart';
import 'package:photo_gallery/utils/utility.dart';

class Styles {
  static ThemeData darkTheme() {
    return ThemeData(
      primarySwatch: MaterialColor(
        parseColorInt('#000000'),
        getColorSwatch(parseColor('#000000')),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
