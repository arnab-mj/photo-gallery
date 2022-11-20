import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_gallery/models/file_response.dart';

// hexSting format #FFFFFF
Color parseColor(String hexString) {
  try {
    return Color(int.parse(hexString.replaceFirst('#', '0x')) + 0xFF000000);
  } catch (e) {
    return Colors.orange;
  }
}

// hexSting format #FFFFFF
int parseColorInt(String hexString) {
  try {
    return int.parse(hexString.replaceFirst('#', '0x')) + 0xFF000000;
  } catch (e) {
    return 0xFF121212;
  }
}

Map<int, Color> getColorSwatch(Color color) {
  return {
    50: Color.fromRGBO(color.red, color.green, color.blue, .1),
    100: Color.fromRGBO(color.red, color.green, color.blue, .2),
    200: Color.fromRGBO(color.red, color.green, color.blue, .3),
    300: Color.fromRGBO(color.red, color.green, color.blue, .4),
    400: Color.fromRGBO(color.red, color.green, color.blue, .5),
    500: Color.fromRGBO(color.red, color.green, color.blue, .6),
    600: Color.fromRGBO(color.red, color.green, color.blue, .7),
    700: Color.fromRGBO(color.red, color.green, color.blue, .8),
    800: Color.fromRGBO(color.red, color.green, color.blue, .9),
    900: Color.fromRGBO(color.red, color.green, color.blue, 1),
  };
}

Widget showLoader(BuildContext context) {
  return Platform.isIOS
      ? CupertinoActivityIndicator(
          color: Theme.of(context).colorScheme.secondary,
        )
      : SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
            strokeWidth: 1.5,
            color: Theme.of(context).colorScheme.secondary,
          ),
      );
}

Future<String> saveFileToDisk(FileResponse response) async {
  String path = '';

  if (Platform.isAndroid) {
    path = "/storage/emulated/0/Download";
  } else if (Platform.isIOS) {
    path = (await getApplicationDocumentsDirectory()).path;
  } else {
    throw Exception('Platform not supported yet');
  }

  if (!await Directory(path).exists()) await Directory(path).create();

  // if file already exists with the same name append number
  List<String> nameWithExt = response.filename.split('.');

  String filePath = '$path/${response.filename}';
  File file = File(filePath);

  int count = 0;
  while (await file.exists() == true) {
    filePath = '$path/${nameWithExt[0]}-($count).${nameWithExt[1]}';
    file = File(filePath);

    count++;
  }
  file = await file.writeAsBytes(response.fileBytes);

  return filePath;
}

showSnackBar(BuildContext context, String? message, [bool isError = false]) {
  if (message == null || message.isEmpty) return;

  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.grey[800],
      content: Text(
        message,
        style: TextStyle(color: isError ? Colors.yellow[300] : Colors.white),
      ),
      duration: Duration(milliseconds: isError ? 2000 : 1000),
    ),
  );
}