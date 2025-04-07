import 'dart:typed_data';

import 'package:detox_app/data/services/selected_apps_hive.dart';
import 'package:detox_app/features/detox/models/app_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

class AppRepository {
  //get all the apps from the device
  Future<List<AppModel>> getInstalledApps() async {
    debugPrint("Entrou na funcao do repository");

    List<AppInfo> installedApps =
        await InstalledApps.getInstalledApps(false, true, true);

    debugPrint("Repository recebeu a funcao do package");

    return installedApps
        .map((app) => AppModel(
            appName: app.name,
            appIcon: app.icon != null && app.icon!.isNotEmpty
                ? app.icon!
                : Uint8List(0),
            appPackageName: app.packageName))
        .toList();
  }

  Future<List<String>> getMonitoredAppsLocalDatabase() async {
    return await getMonitoredApps();
  }

  Future<void> saveMonitoredAppsLocalDatabase(List<String> packageNames) async {
    List<String> existingApps = await getMonitoredApps();
    packageNames.addAll(existingApps);

    await setMonitoredApps(packageNames);
  }

  Future<List<AppModel>> getAppsByListNames(List<String> packageNames) async {
    List<AppInfo> installedApps =
        await InstalledApps.getInstalledApps(false, true, true);

    List<AppModel> apps = [];

// Filter and add only the apps that are in our packageNames list
    for (var app in installedApps) {
      if (packageNames.contains(app.packageName)) {
        apps.add(
          AppModel(
            appName: app.name,
            appIcon: app.icon ?? Uint8List(0),
            appPackageName: app.packageName,
          ),
        );
      }
    }
    return apps;
  }

  Future<AppModel?> getSingleAppByName(String packageName) async {
    List<AppInfo> installedApps =
        await InstalledApps.getInstalledApps(false, true, true);

    // Filter and add only the apps that are in our packageNames list
    for (var app in installedApps) {
      if (packageName.contains(app.packageName)) {
        return AppModel(
          appName: app.name,
          appIcon: app.icon ?? Uint8List(0),
          appPackageName: app.packageName,
        );
      }
    }
    return null;
  }

  Future<void> saveSelectedApps(Map<String, bool> selectedApps) async {
    setSelectedAppsMap(selectedApps);
  }

  Future<void> setAppsTimeLimit(List<String> apps, int time) async {
    Map<String, int> appTimeMap = getAppTimeMap();
    appTimeMap.addAll({for (var app in apps) app: time});
    setAppTimeMap(appTimeMap);
  }
}
