import 'package:flutter/material.dart';
import 'package:photo_gallery/blocs/gallery_bloc.dart';
import 'package:photo_gallery/models/photos_list_response.dart';
import 'package:photo_gallery/network/api_response.dart';
import 'package:photo_gallery/utils/app_constant.dart';
import 'package:photo_gallery/utils/utility.dart';
import 'package:photo_gallery/views/gallery_screen/widgets/gallery_image_box.dart';
import 'package:photo_gallery/widgets/error.dart';

import '../photo_preview_screen/photo_preview_screen.dart';

class GalleryScreen extends StatefulWidget {
  static const String routeName = 'gallery-screen';

  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final GalleryBloc _bloc = GalleryBloc();

  @override
  void initState() {
    super.initState();

    _bloc.requestNextPageStream.listen((event) {
      if (event.status == Status.loading) {
      } else if (event.status == Status.completed) {
        setState(() {});
      } else if (event.status == Status.error) {
        showSnackBar(context, event.message, true);
      }
    });

    _bloc.getInitialPhotosList();
  }

  @override
  void dispose() {
    super.dispose();

    _bloc.dispose();
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
          return photosGridView();
        } else if (snapshot.data?.status == Status.error) {
          return Error(errorMessage: snapshot.data?.message, onRetryPressed: () => _bloc.getInitialPhotosList());
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget photosGridView() {
    return GridView.builder(
      controller: _bloc.scrollController,
      itemBuilder: (context, index) {
        return InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                PhotoPreviewScreen.routeName,
                arguments: PhotoPreviewScreenArgs(
                  photoList: _bloc.photoList,
                  index: index,
                ),
              );
            },
            child: GalleryImageBox(photo: _bloc.photoList[index]),
        );
      },
      itemCount: _bloc.photoList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: (MediaQuery.of(context).size.width / AppConstant.galleryThumbnailSize).round(),
        crossAxisSpacing: AppConstant.galleryCrossAxisSpacing,
        mainAxisSpacing: AppConstant.galleryMainAxisSpacing,
      ),
      scrollDirection: Axis.vertical,
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.grey[900],
      centerTitle: true,
      title: const Text(
        'Photo Gallery',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: rootWidget(),
    );
  }
}
