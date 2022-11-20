import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/models/photos_list_response.dart';
import 'package:photo_gallery/utils/utility.dart';
import 'package:photo_gallery/views/photo_preview_screen/widgets/photo_preview_actions.dart';
import 'package:photo_view/photo_view_gallery.dart';

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

  late PageController _pageController;

  _PhotoPreviewScreenState(this.photoList, this.index);

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: index);
  }

  @override
  void dispose() {
    super.dispose();

    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            pageController: _pageController,
            itemCount: photoList.length,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: CachedNetworkImageProvider(photoList[index].downloadUrl ?? ''),
              );
            },
            loadingBuilder: (context, event) {
              return showLoader(context);
            },
            onPageChanged: (i) => index = i,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: PhotoPreviewActions(photo: photoList[index]),
          ),
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
