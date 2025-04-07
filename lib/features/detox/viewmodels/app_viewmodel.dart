import 'package:detox_app/data/repositories/app_repository.dart';
import 'package:detox_app/features/detox/models/app_model.dart';
import 'package:flutter/material.dart';

class AppViewModel extends ChangeNotifier {
  final AppRepository _repository = AppRepository();

  List<AppModel> appsList = [];
  Map<String, bool> selectedAppsMap = {};
  List<AppModel> monitoredApps = [];
  bool _isLoading = false;

  Future<void> getAppsList() async {
    //get all the apps from the device
    try {
      final installedApps = await _repository.getInstalledApps();

      final monitoredAppsPackageName =
          await _repository.getMonitoredAppsLocalDatabase();

      _processInstalledApps(installedApps, monitoredAppsPackageName);
    } catch (e) {
      debugPrint("Error loading apps: $e");
    }
  }

  void _processInstalledApps(
      List<AppModel> installedApps, List<String> monitoredAppsPackageName) {
    for (var app in installedApps) {
      bool exists = appsList.any(
          (existingApp) => existingApp.appPackageName == app.appPackageName);

      if (!exists && !monitoredAppsPackageName.contains(app.appPackageName)) {
        appsList.add(app);
      }

      selectedAppsMap.putIfAbsent(app.appPackageName, () => false);
    }
    notifyListeners();
  }

  Future<bool> loadMonitoredApps(BuildContext context) async {
    try {
      // await Future.delayed(const Duration(seconds: 2)); // Delay intencional
      final apps = await getMonitoredAppsLocalDatabase();
      if (!context.mounted) return false;

      await getSpecificApps(apps);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> getSpecificApps(List<String> packageNames) async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      monitoredApps.clear();
      notifyListeners();

      // Get all installed apps at once
      monitoredApps = await _repository.getAppsByListNames(packageNames);
    } catch (e) {
      debugPrint("Error in the function getSpecificApps: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<AppModel?> returnAppModel(String packageName) async {
    try {
      return await _repository.getSingleAppByName(packageName);
    } catch (e) {
      debugPrint("Error getting app by package name: $e");
      return null;
    }
  }

  void updateSelectedApps(Map<String, bool> selecteds) {
    selectedAppsMap = selecteds;
    notifyListeners();
  }

  Future<void> setMonitoredAppsLocalDatabase() async {
    List<String> saveAppsPackageName = [];
    //get checked apps
    var newApps = appsList
        .where((app) => selectedAppsMap[app.appPackageName] == true)
        .toList();

    // Add the apps to the monitoredApps if they are not already there
    saveAppsPackageName = _updateMonitoredAppsList(newApps);

    //add too the apps who are already in the list and save in the database
    await _repository.saveMonitoredAppsLocalDatabase(saveAppsPackageName);

    notifyListeners();
  }

  List<String> _updateMonitoredAppsList(List<AppModel> newApps) {
    List<String> saveAppsPackageName = [];
    for (var app in newApps) {
      if (!monitoredApps
          .any((monitored) => monitored.appPackageName == app.appPackageName)) {
        monitoredApps.add(app);
        saveAppsPackageName.add(app.appPackageName);
      }
    }
    notifyListeners();
    return saveAppsPackageName;
  }

  void setSelectedAppsLocalDatabase() {
    if (selectedAppsMap.isEmpty) {
      debugPrint("Error: Trying to save an empty map!");
      return;
    }

    _repository.saveSelectedApps(selectedAppsMap);
  }

  Future<List<String>> getMonitoredAppsLocalDatabase() async {
    return await _repository.getMonitoredAppsLocalDatabase();
  }

  void setMapAppsTime(List<String> apps, int time) {
    _repository.setAppsTimeLimit(apps, time);
  }

  void clearAppsList() {
    appsList.clear();
    selectedAppsMap.clear();
    notifyListeners();
  }
}
