import 'package:permission_handler/permission_handler.dart';

class AppPermissionHandler {
  Future<bool> hasStoragePermission() async {
    PermissionStatus status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request().then((value) async {
          if (value.isGranted) {
            return true;
          } else {
            return false;
          }
        });
      }
    return true;
  }
}