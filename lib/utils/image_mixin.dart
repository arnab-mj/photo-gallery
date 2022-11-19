import 'package:photo_gallery/utils/app_constant.dart';

mixin ImageMixin {
  conciseImagePixel(String? photoUrl) {
    removeUntilLastOccuernce(String str, String pattern) {
      return str.substring(0, str.lastIndexOf(pattern));
    }

    photoUrl = photoUrl != null ? '${removeUntilLastOccuernce(removeUntilLastOccuernce(photoUrl, '/'), '/')}/${AppConstant.galleryThumbnailSizeInt}/${AppConstant.galleryThumbnailSizeInt}' : photoUrl;
    return photoUrl;
  }
}
