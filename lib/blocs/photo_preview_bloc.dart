import 'dart:async';

import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:photo_gallery/blocs/base_bloc.dart';
import 'package:photo_gallery/models/wallpaper.dart';
import 'package:photo_gallery/network/api_response.dart';
import 'package:photo_gallery/repositories/photos_repository.dart';
import 'package:photo_gallery/utils/app_permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class PhotoPreviewBloc extends BaseBloc {
  final PhotosRepository _repo = PhotosRepository();
  final StreamController<ApiResponse<dynamic>> _scLoader = StreamController<ApiResponse<dynamic>>();

  StreamSink<ApiResponse<dynamic>> get loaderSink => _scLoader.sink;
  Stream<ApiResponse<dynamic>> get loaderStream => _scLoader.stream;

  void sharePhoto(String downloadUrl) async {
    loaderSink.add(ApiResponse.loading());

    try {
      String response = await _repo.getPhoto(downloadUrl);
      Share.shareXFiles([XFile(response)]);

      loaderSink.add(ApiResponse.completed({}));
    } catch (e) {
      loaderSink.add(ApiResponse.error(e.toString()));
    }
  }

  void setWallpaper(String downloadUrl, WallpaperMode wallpaperMode) async {
    loaderSink.add(ApiResponse.loading());

    try {
      String response = await _repo.getPhoto(downloadUrl);
      await WallpaperManager.setWallpaperFromFile(response, wallpaperMode.value);

      loaderSink.add(ApiResponse.completed('Wallpaper applied successfully.'));
    } catch (e) {
      loaderSink.add(ApiResponse.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _scLoader.close();
  }
}
