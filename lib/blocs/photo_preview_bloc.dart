import 'dart:async';

import 'package:photo_gallery/blocs/base_bloc.dart';
import 'package:photo_gallery/network/api_response.dart';
import 'package:photo_gallery/repositories/photos_repository.dart';
import 'package:photo_gallery/utils/app_permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class PhotoPreviewBloc extends BaseBloc {
  final PhotosRepository _repo = PhotosRepository();
  final StreamController<ApiResponse<dynamic>> _scphotoShare = StreamController<ApiResponse<dynamic>>();

  StreamSink<ApiResponse<dynamic>> get photoShareSink => _scphotoShare.sink;
  Stream<ApiResponse<dynamic>> get photoShareStream => _scphotoShare.stream;

  void sharePhoto(String downloadUrl) async {
    photoShareSink.add(ApiResponse.loading());

    try {
      if (await AppPermissionHandler().hasStoragePermission()) {
        String response = await _repo.getPhoto(downloadUrl);
        Share.shareXFiles([XFile(response)]);
      } else {
        throw ('Storage permission denied.');
      }

      photoShareSink.add(ApiResponse.completed({}));
    } catch (e) {
      photoShareSink.add(ApiResponse.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _scphotoShare.close();
  }
}
