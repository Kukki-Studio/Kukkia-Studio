import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> checkNotification() async {
    if (kIsWeb) return true;
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  static Future<bool> checkStorage() async {
    if (kIsWeb) return true;
    final status = await Permission.photos.status;
    return status.isGranted;
  }

  static Future<bool> requestNotification() async {
    if (kIsWeb) return true;
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  static Future<bool> requestStorage() async {
    if (kIsWeb) return true;
    final status = await Permission.photos.request();
    return status.isGranted;
  }
}
