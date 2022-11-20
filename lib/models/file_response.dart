import 'dart:typed_data';

class FileResponse {
  final Uint8List fileBytes;
  final String filename;

  FileResponse({required this.fileBytes, required this.filename});
}
