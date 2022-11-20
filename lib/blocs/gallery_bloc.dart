import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:photo_gallery/blocs/base_bloc.dart';
import 'package:photo_gallery/models/photos_list_response.dart';
import 'package:photo_gallery/network/api_base_helper.dart';
import 'package:photo_gallery/network/api_response.dart';
import 'package:photo_gallery/repositories/photos_repository.dart';
import 'package:photo_gallery/utils/app_hive.dart';

class GalleryBloc extends BaseBloc {
  final PhotosRepository _repo = PhotosRepository();
  final StreamController<ApiResponse<List<Photo>>> _scPhotosList = StreamController<ApiResponse<List<Photo>>>();
  final StreamController<ApiResponse<List<Photo>>> _scRequestNextPage = StreamController<ApiResponse<List<Photo>>>();

  StreamSink<ApiResponse<List<Photo>>> get photosListSink => _scPhotosList.sink;
  Stream<ApiResponse<List<Photo>>> get photosListStream => _scPhotosList.stream;

  StreamSink<ApiResponse<List<Photo>>> get requestNextPageSink => _scRequestNextPage.sink;
  Stream<ApiResponse<List<Photo>>> get requestNextPageStream => _scRequestNextPage.stream;

  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  final List<Photo> _photoList = [];

  List<Photo> get photoList => _photoList;

  int pageNumber = 1;
  bool hasNextPage = true;

  GalleryBloc() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange && hasNextPage) {
        requestNextPage();
      }
    });
  }

  void getPhotoList(StreamSink<ApiResponse<List<Photo>>> sink, [bool checkDB = false]) async {
    sink.add(ApiResponse.loading());

    try {
      var photoListBox = await Hive.openBox<Photo>(AppHive.photoListBox);
      var photoGalleryBox = await Hive.openBox(AppHive.photoGalleryBox);

      if (checkDB && photoListBox.values.isNotEmpty) {
        _photoList.addAll(photoListBox.values);

        hasNextPage = photoGalleryBox.get(AppHive.hasNextPageKey);
        pageNumber = photoGalleryBox.get(AppHive.nextPageNumberKey);

        sink.add(ApiResponse.completed(null));

        return;
      }

      if (hasNextPage) {
        final Response<List<Photo>> response = await _repo.getPhotosList(pageNumber);

        if (response.headers['link'].toString().contains('rel="next"')) {
          hasNextPage = true;
          pageNumber++;
        } else {
          hasNextPage = false;
        }

        _photoList.addAll(response.body);

        // Store information to DB
        photoListBox.addAll(response.body);

        photoGalleryBox.put(AppHive.nextPageNumberKey, pageNumber);
        photoGalleryBox.put(AppHive.hasNextPageKey, hasNextPage);
      }

      sink.add(ApiResponse.completed(null));
    } catch (e) {
      sink.add(ApiResponse.error(e.toString()));
    }
  }

  void getInitialPhotosList() async {
    getPhotoList(photosListSink, true);
  }

  void requestNextPage() async {
    getPhotoList(requestNextPageSink);
  }

  @override
  void dispose() {
    _scPhotosList.close();
    _scRequestNextPage.close();
    _scrollController.dispose();
    Hive.close();
  }
}
