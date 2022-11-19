import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  final String? url;
  final double? height, width;
  final BoxFit? fit;

  CachedImage({this.url, this.height, this.width, this.fit, super.key}) {}

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      errorWidget: (context, url, error) => Image.asset('assets/images/error.png'),
      placeholder: (context, url) => Image.asset('assets/images/placeholder.png'),
      imageUrl: url ?? '',
      fit: fit,
      height: height,
      width: width,
    );
  }
}
