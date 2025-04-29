import 'dart:typed_data';

import 'package:detox_app/data/repositories/selected_apps_storage_repository.dart';
import 'package:detox_app/data/repositories/time_storage_repository.dart';
import 'package:detox_app/features/detox/models/app_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

class AppRepository {
  final SelectedAppsStorageRepository _selectedApps;
  final TimeStorageRepository _timeStorage;

  AppRepository(
      {required SelectedAppsStorageRepository selectedApps,
      required TimeStorageRepository timeStorage})
      : _selectedApps = selectedApps,
        _timeStorage = timeStorage;

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
    return await _selectedApps.getMonitoredApps();
  }

  Future<void> saveMonitoredAppsLocalDatabase(List<String> packageNames) async {
    List<String> existingApps = await _selectedApps.getMonitoredApps();
    packageNames.addAll(existingApps);

    await _selectedApps.setMonitoredApps(packageNames);
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
    _selectedApps.setSelectedAppsMap(selectedApps);
  }

  Future<void> setAppsTimeLimit(List<String> apps, int time) async {
    Map<String, int> appTimeMap = _selectedApps.getAppTimeMap();
    appTimeMap.addAll({for (var app in apps) app: time});
    _selectedApps.setAppTimeMap(appTimeMap);
  }

  Future<void> deleteApp(String packageName) async {
    debugPrint(
        "Monitored apps antes de deletar: ${_selectedApps.getMonitoredApps()}");
    //Turn false
    Map<String, bool> selectedAppsMap = _selectedApps.getSelectedAppsMap();
    selectedAppsMap[packageName] = false;
    _selectedApps.setSelectedAppsMap(selectedAppsMap);

    //Remove from monitored apps list
    List<String> monitoredAppsList = await _selectedApps.getMonitoredApps();
    monitoredAppsList.remove(packageName);
    debugPrint("monitoredAppsList: $monitoredAppsList");
    await _selectedApps.setMonitoredApps(monitoredAppsList);

    //Remove from app time map
    Map<String, int> appTimeMap = _selectedApps.getAppTimeMap();
    appTimeMap.remove(packageName);
    _selectedApps.setAppTimeMap(appTimeMap);

    //remove from current usage time map
    Map<String, int> currentTimeMap = _timeStorage.getMapAppsCurrentTime();
    currentTimeMap.remove(packageName);
    _timeStorage.setMapAppsCurrentTime(currentTimeMap);

    //remove from acrescim mode bool map
    Map<String, bool> acrecismModeMap = _timeStorage.getMapAppAcrescimBool();
    acrecismModeMap.remove(packageName);
    _timeStorage.setMapAppAcrescimBool(acrecismModeMap);

    //remove from acrescim mode time map
    Map<String, int> acrecismTimeMap =
        _timeStorage.getMapAppTimeAcrescimLimit();
    acrecismTimeMap.remove(packageName);
    _timeStorage.setMapAppTimeAcrescimLimit(acrecismTimeMap);

    //remove from acrescim current time map
    Map<String, int> acrecismCurrentTimeMap =
        _timeStorage.getMapAppAcrescimCurrentTime();
    acrecismCurrentTimeMap.remove(packageName);
    _timeStorage.setMapAppAcrescimCurrentTime(acrecismCurrentTimeMap);

    //remove from monitored apps usage time
    Map<String, int> monitoredAppsUsageTime = _timeStorage.getMapAppUsageTime();
    monitoredAppsUsageTime.remove(packageName);
    _timeStorage.setMapAppUsageTime(monitoredAppsUsageTime);

    debugPrint(
        "Monitored apps depois de deletar: ${_selectedApps.getMonitoredApps()}");
  }
}
