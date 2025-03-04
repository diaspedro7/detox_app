import 'package:detox_app/data/services/selected_apps_hive.dart';
import 'package:detox_app/features/detox/models/app_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

class AppViewModel extends ChangeNotifier {
  List<AppModel> appsList = [];
  Map<String, bool> selectedAppsMap = {};

  List<AppModel> monitoredApps = [];

  void getAppsList() async {
    //get all the apps from the device
    List<AppInfo> installedApps =
        await InstalledApps.getInstalledApps(false, true, true);

    List<String> monitoredAppsPackageName = getMonitoredAppsLocalDatabase();

    //check if the app is already in the appList. It does it so the app is not added again
    for (var app in installedApps) {
      //debugPrint("App: ${app.name}, Icon: ${app.icon}");

      //check if the appList contains the app
      bool exists = appsList
          .any((existingApp) => existingApp.appPackageName == app.packageName);

      if (!exists && !monitoredAppsPackageName.contains(app.packageName)) {
        //add the app to the appList if does not
        appsList.add(AppModel(
            appName: app.name,
            appIcon: app.icon != null && app.icon!.isNotEmpty
                ? app.icon!
                : Uint8List(0),
            appPackageName: app.packageName));
      }
      //put in the selectedAppsMap if does not exist yet
      selectedAppsMap.putIfAbsent(app.packageName, () => false);
    }
    notifyListeners();
  }

  void selectApp(String packageName) {
    selectedAppsMap[packageName] = !selectedAppsMap[packageName]!;
    notifyListeners();
  }

  void addMonitoredApps() {
    List<String> saveAppsPackageName = [];
    //get checked apps
    var newApps =
        appsList.where((app) => selectedAppsMap[app.appPackageName]!).toList();

    // AAdd the apps to the monitoredApps if they are not already there
    for (var app in newApps) {
      if (!monitoredApps
          .any((monitored) => monitored.appPackageName == app.appPackageName)) {
        monitoredApps.add(app);
        saveAppsPackageName.add(app.appPackageName);
      }
    }
    setMonitoredApps(saveAppsPackageName);
    notifyListeners();
  }

  void setSelectedAppsLocalDatabase() {
    setSelectedAppsMap(selectedAppsMap);
  }

  List<String> getMonitoredAppsLocalDatabase() {
    return getMonitoredApps();
  }

  void setMapMonitoredAppsTime(List<String> apps, int time) {
    Map<String, int> appTimeMap = getAppTimeMap();
    appTimeMap.addAll({for (var app in apps) app: time});
    setAppTimeMap(appTimeMap);
  }
}
