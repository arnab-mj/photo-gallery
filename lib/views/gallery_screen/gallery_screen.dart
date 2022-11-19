import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:photo_gallery/blocs/gallery_bloc.dart';
import 'package:photo_gallery/models/photos_list_response.dart';
import 'package:photo_gallery/network/api_response.dart';
import 'package:photo_gallery/utils/app_constant.dart';
import 'package:photo_gallery/utils/utility.dart';
import 'package:photo_gallery/views/gallery_screen/widgets/gallery_image_box.dart';
import 'package:photo_gallery/widgets/cached_image.dart';
import 'package:photo_gallery/widgets/error.dart';

class GalleryScreen extends StatefulWidget {
  static const String routeName = 'gallery-screen';

  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final ScrollController _scrollController = ScrollController();
  final GalleryBloc _bloc = GalleryBloc();

  @override
  void initState() {
    super.initState();

    _bloc.getPhotosList();
  }

  @override
  void dispose() {
    super.dispose();

    _bloc.dispose();
    _scrollController.dispose();
  }

  Widget photosGridView(List<Photo>? photosList) {
    return GridView.builder(
      controller: _scrollController,
      itemBuilder: (context, index) {
        return GalleryImageBox(photo: photosList![index]);
      },
      itemCount: photosList?.length ?? 0,
      primary: false,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: (MediaQuery.of(context).size.width / AppConstant.galleryThumbnailSize).round(),
        crossAxisSpacing: AppConstant.galleryCrossAxisSpacing,
        mainAxisSpacing: AppConstant.galleryMainAxisSpacing,
      ),
      scrollDirection: Axis.vertical,
    );
  }

  Widget rootWidget() {
    return StreamBuilder<ApiResponse<List<Photo>>>(
      stream: _bloc.photosListStream,
      builder: (context, snapshot) {
        if (snapshot.data?.status == Status.loading) {
          return Center(
            child: showLoader(context),
          );
        } else if (snapshot.data?.status == Status.completed) {
          return photosGridView(snapshot.data?.data);
        } else if (snapshot.data?.status == Status.error) {
          return Error(errorMessage: snapshot.data?.message, onRetryPressed: () => _bloc.getPhotosList());
        }

        return const SizedBox.shrink();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Photo Gallery',
        ),
      ),
      body: rootWidget(),
    );
  }
}
