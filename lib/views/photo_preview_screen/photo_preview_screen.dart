import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/blocs/photo_preview_bloc.dart';
import 'package:photo_gallery/models/photos_list_response.dart';
import 'package:photo_gallery/network/api_response.dart';
import 'package:photo_gallery/utils/utility.dart';
import 'package:photo_gallery/widgets/loader_dialog.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'widgets/photo_preview_action_button.dart';

class PhotoPreviewScreen extends StatefulWidget {
  static const String routeName = '/photo-preview-screen';

  final PhotoPreviewScreenArgs args;

  const PhotoPreviewScreen({Key? key, required this.args}) : super(key: key);

  @override
  State<PhotoPreviewScreen> createState() => _PhotoPreviewScreenState(args.photoList, args.index);
}

class _PhotoPreviewScreenState extends State<PhotoPreviewScreen> {
  List<Photo> photoList;
  int index;

  late int _currentIndex;
  late PageController _pageController;
  final PhotoPreviewBloc _bloc = PhotoPreviewBloc();

  _PhotoPreviewScreenState(this.photoList, this.index);

  @override
  void initState() {
    super.initState();

    _currentIndex = index;
    _pageController = PageController(initialPage: index);

    _bloc.photoShareStream.listen((event) {
      if (event.status == Status.loading) {
        DialogBuilder(context).showLoader();
      } else if (event.status == Status.completed) {
        DialogBuilder(context).hideLoader();
      } else if (event.status == Status.error) {
        DialogBuilder(context).hideLoader();
        showSnackBar(context, event.message, true);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _pageController.dispose();
  }

  Widget photoView() {
    return PhotoViewGallery.builder(
      pageController: _pageController,
      itemCount: photoList.length,
      enableRotation: true,
      builder: (context, index) {
        return PhotoViewGalleryPageOptions(
          imageProvider: CachedNetworkImageProvider(photoList[index].downloadUrl ?? ''),
        );
      },
      loadingBuilder: (context, event) {
        return showLoader(context);
      },
      onPageChanged: (index) {
        _currentIndex = index;
      },
    );
  }

  Widget photoViewActions() {
    return Container(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PhotoPreviewActionButton(
            iconData: Icons.share,
            onPressed: () {
              if (photoList[_currentIndex].downloadUrl != null) {
                _bloc.sharePhoto(photoList[_currentIndex].downloadUrl!);
              }
            },
          ),
          PhotoPreviewActionButton(
            iconData: Icons.photo,
            onPressed: () {
              // todo set photo as wallpaper
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Gallery'),
      ),
      body: Stack(
        children: [
          photoView(),
          Align(alignment: Alignment.bottomCenter, child: photoViewActions()),
        ],
      ),
    );
  }
}

class PhotoPreviewScreenArgs {
  List<Photo> photoList;
  int index;

  PhotoPreviewScreenArgs({required this.photoList, required this.index});
}
