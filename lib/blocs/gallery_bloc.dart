import 'dart:async';

import 'package:photo_gallery/blocs/base_bloc.dart';
import 'package:photo_gallery/models/photos_list_response.dart';
import 'package:photo_gallery/network/api_response.dart';
import 'package:photo_gallery/repositories/photos_repository.dart';

class GalleryBloc extends BaseBloc {
  final PhotosRepository _repo = PhotosRepository();
  final StreamController<ApiResponse<List<Photo>>> _scPhotosList = StreamController<ApiResponse<List<Photo>>>();

  StreamSink<ApiResponse<List<Photo>>> get photosListSink => _scPhotosList.sink;
  Stream<ApiResponse<List<Photo>>> get photosListStream => _scPhotosList.stream;

  int pageNumber = 1;

  void getPhotosList() async {
    photosListSink.add(ApiResponse.loading());

    try {
      final List<Photo> response = (await _repo.getPhotosList(pageNumber)).body;
      photosListSink.add(ApiResponse.completed(response));
    } catch (e) {
      photosListSink.add(ApiResponse.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _scPhotosList.close();
  }
}
