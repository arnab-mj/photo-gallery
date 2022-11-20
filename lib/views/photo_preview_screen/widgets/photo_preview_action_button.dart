import 'package:flutter/material.dart';

class PhotoPreviewActionButton extends StatelessWidget {
  final IconData iconData;
  final Function onPressed;

  const PhotoPreviewActionButton({super.key, required this.iconData, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<OutlinedBorder?>(const CircleBorder()),
        backgroundColor: MaterialStateProperty.all<Color?>(Colors.grey[800]),
      ),
      child: Icon(
        iconData,
      ),
      onPressed: () => onPressed(),
    );
  }
}
