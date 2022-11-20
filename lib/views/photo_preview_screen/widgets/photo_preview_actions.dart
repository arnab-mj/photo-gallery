import 'package:flutter/material.dart';
import 'package:photo_gallery/models/photos_list_response.dart';
import 'package:photo_gallery/views/photo_preview_screen/widgets/photo_preview_action_button.dart';

class PhotoPreviewActions extends StatelessWidget {
  const PhotoPreviewActions({
    Key? key,
    required this.photo,
  }) : super(key: key);

  final Photo photo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PhotoPreviewActionButton(
            iconData: Icons.share,
            onPressed: () {
              // todo share photo
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
}