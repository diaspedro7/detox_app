import 'package:detox_app/features/detox/models/app_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

class AppViewModel extends ChangeNotifier {
  List<AppModel> appsList = [];

  void getInstalledApps() async {
    List<AppInfo> installedApps = await InstalledApps.getInstalledApps();

    for (var app in installedApps) {
      debugPrint("App: ${app.name}, Icon: ${app.icon}");

      appsList.add(AppModel(
          appName: app.name,
          appIcon: app.icon != null && app.icon!.isNotEmpty
              ? app.icon!
              : Uint8List(0),
          appPackageName: app.packageName));
    }
    notifyListeners();
  }
}
