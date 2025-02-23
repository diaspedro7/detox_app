import 'package:detox_app/data/services/selected_apps_hive.dart';
import 'package:detox_app/features/detox/models/app_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

class AppViewModel extends ChangeNotifier {
  List<AppModel> appsList = [];
  Map<String, bool> selectedAppsMap = {};

  bool appsListViewVisibility = false;

  void getAppsList() async {
    List<AppInfo> installedApps = await InstalledApps.getInstalledApps();

    selectedAppsMap = getSelectedAppsMap();

    for (var app in installedApps) {
      debugPrint("App: ${app.name}, Icon: ${app.icon}");

      bool exists = appsList
          .any((existingApp) => existingApp.appPackageName == app.packageName);

      if (!exists) {
        appsList.add(AppModel(
            appName: app.name,
            appIcon: app.icon != null && app.icon!.isNotEmpty
                ? app.icon!
                : Uint8List(0),
            appPackageName: app.packageName));
      }
      //put if does not exist yet
      selectedAppsMap.putIfAbsent(app.packageName, () => false);
    }
    notifyListeners();
  }

  void selectApp(String packageName) {
    selectedAppsMap[packageName] = !selectedAppsMap[packageName]!;
    notifyListeners();
  }

  void toggleAppsListViewVisibility() {
    appsListViewVisibility = !appsListViewVisibility;
    notifyListeners();
  }

  void setSelectedAppsLocalDatabase() {
    setSelectedAppsMap(selectedAppsMap);
  }
}
