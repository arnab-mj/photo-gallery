import 'package:flutter/material.dart';
import 'package:photo_gallery/models/photos_list_response.dart';
import 'package:photo_gallery/utils/app_constant.dart';
import 'package:photo_gallery/utils/image_mixin.dart';
import 'package:photo_gallery/widgets/cached_image.dart';

class GalleryImageBox extends StatelessWidget with ImageMixin {
  const GalleryImageBox({
    Key? key,
    required this.photo,
  }) : super(key: key);

  final Photo photo;

  @override
  Widget build(BuildContext context) {
    return CachedImage(
      url: conciseImagePixel(photo.downloadUrl),
      height: AppConstant.galleryThumbnailSize,
      width: AppConstant.galleryThumbnailSize,
    );
  }
}