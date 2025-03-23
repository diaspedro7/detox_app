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

  Future<void> getAppsList() async {
    //get all the apps from the device
    List<AppInfo> installedApps =
        await InstalledApps.getInstalledApps(false, true, true);

    List<String> monitoredAppsPackageName =
        await getMonitoredAppsLocalDatabase();
    debugPrint("Local database: $monitoredAppsPackageName");

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

  Future<void> getSpecificApps(List<String> packageNames) async {
    monitoredApps.clear();

    // Get all installed apps at once
    List<AppInfo> installedApps =
        await InstalledApps.getInstalledApps(false, true, true);

    // Filter and add only the apps that are in our packageNames list
    for (var app in installedApps) {
      if (packageNames.contains(app.packageName)) {
        monitoredApps.add(
          AppModel(
            appName: app.name,
            appIcon: app.icon ?? Uint8List(0),
            appPackageName: app.packageName,
          ),
        );
      }
    }

    notifyListeners();
  }

  Future<AppModel?> returnAppModel(String appPackageName) async {
    List<AppInfo> installedApps =
        await InstalledApps.getInstalledApps(false, true, true);

    // Filter and add only the apps that are in our packageNames list
    for (var app in installedApps) {
      if (appPackageName.contains(app.packageName)) {
        return AppModel(
          appName: app.name,
          appIcon: app.icon ?? Uint8List(0),
          appPackageName: app.packageName,
        );
      }
    }
    return null;
  }

  // Future<void> getSpecificApps(List<String> packageNames) async {
  //   monitoredApps.clear();

  //   for (String packageName in packageNames) {
  //     final AppInfo? appInfo = await InstalledApps.getAppInfo(
  //         packageName, BuiltWith.native_or_others);

  //     if (appInfo != null) {
  //       monitoredApps.add(
  //         AppModel(
  //           appName: appInfo.name,
  //           appIcon: appInfo.icon ?? Uint8List(0),
  //           appPackageName: appInfo.packageName,
  //         ),
  //       );
  //     }
  //   }

  //   notifyListeners();
  // }

  //Got substituted by the selectPageStateController
  // void selectApp(String packageName) {
  //   selectedAppsMap[packageName] = !selectedAppsMap[packageName]!;
  //   notifyListeners();
  // }

  void recieveSelectedApps(Map<String, bool> selecteds) {
    selectedAppsMap = selecteds;
    notifyListeners();
  }

  Future<void> setMonitoredAppsLocalDatabase() async {
    List<String> saveAppsPackageName = [];
    //get checked apps
    var newApps = appsList
        .where((app) => selectedAppsMap[app.appPackageName] == true)
        .toList();

    // AAdd the apps to the monitoredApps if they are not already there
    for (var app in newApps) {
      if (!monitoredApps
          .any((monitored) => monitored.appPackageName == app.appPackageName)) {
        monitoredApps.add(app);
        saveAppsPackageName.add(app.appPackageName);
      }
    }
    //add too the apps who are already in the list
    saveAppsPackageName.addAll(await getMonitoredApps());

    await setMonitoredApps(saveAppsPackageName);
    notifyListeners();
  }

  void setSelectedAppsLocalDatabase() {
    //debugPrint("Iniciando salvamento - selectedAppsMap: $selectedAppsMap");
    if (selectedAppsMap.isEmpty) {
      debugPrint("Erro: Tentando salvar um mapa vazio!");
      return;
    }

    setSelectedAppsMap(selectedAppsMap);
  }

  Future<List<String>> getMonitoredAppsLocalDatabase() async {
    return await getMonitoredApps();
  }

  void setMapAppsTime(List<String> apps, int time) {
    Map<String, int> appTimeMap = getAppTimeMap();
    appTimeMap.addAll({for (var app in apps) app: time});
    setAppTimeMap(appTimeMap);
  }

  void clearAppsList() {
    appsList.clear();
    selectedAppsMap.clear();
    notifyListeners();
  }
}
