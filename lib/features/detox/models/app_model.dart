import 'dart:typed_data';

class AppModel {
  String appName;
  String appPackageName;
  Uint8List appIcon;

  AppModel(
      {required this.appName,
      required this.appPackageName,
      required this.appIcon});
}
