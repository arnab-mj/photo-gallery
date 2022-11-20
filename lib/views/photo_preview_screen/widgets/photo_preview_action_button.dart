import 'package:flutter/material.dart';

class PhotoPreviewActionButton extends StatefulWidget {
  final IconData iconData;
  final Function onPressed;

  const PhotoPreviewActionButton({super.key, required this.iconData, required this.onPressed});

  @override
  State<PhotoPreviewActionButton> createState() => _PhotoPreviewActionButtonState();
}

class _PhotoPreviewActionButtonState extends State<PhotoPreviewActionButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<OutlinedBorder?>(const CircleBorder()),
        backgroundColor: MaterialStateProperty.all<Color?>(Colors.grey[800]),
      ),
      child: Icon(
        widget.iconData,
      ),
      onPressed: () => widget.onPressed(),
    );
  }
}
