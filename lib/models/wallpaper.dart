import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';

enum WallpaperMode { lockscreen, homescreen, both }

extension WallpaperModeExtension on WallpaperMode {
  int get value {
    switch (this) {
      case WallpaperMode.lockscreen:
        return WallpaperManager.LOCK_SCREEN;
      case WallpaperMode.homescreen:
        return WallpaperManager.HOME_SCREEN;
      case WallpaperMode.both:
        return WallpaperManager.BOTH_SCREEN;
      default:
        return 0;
    }
  }

  String get names {
    switch (this) {
      case WallpaperMode.lockscreen:
        return 'Lock Screen';
      case WallpaperMode.homescreen:
        return 'Home Screen';
      case WallpaperMode.both:
        return 'Both Home Screen and Lock Screen';
      default:
        return '';
    }
  }
}

List<WallpaperMode> wallpaperModes = [WallpaperMode.lockscreen, WallpaperMode.homescreen, WallpaperMode.both];
