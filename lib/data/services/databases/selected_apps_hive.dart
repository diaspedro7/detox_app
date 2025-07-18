import 'package:detox_app/data/interfaces/selected_apps_storage_interface.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SelectedAppsStorageHiveDataSource implements ISelectedAppsStorage {
  final boxSAS = Hive.box("selectedAppsStorage");

// --- Save the all apps package name and if their are selected or not ---

  @override
  void setSelectedAppsMap(Map<String, bool> selectedAppsMap) {
    boxSAS.put("selectedAppsMap", Map<String, bool>.from(selectedAppsMap));
  }

  @override
  Map<String, bool> getSelectedAppsMap() {
    final result = Map<String, bool>.from(
        boxSAS.get("selectedAppsMap", defaultValue: <String, bool>{}));
    return result;
  }

// -------------X----------------

// --- Save the apps package name that are monitored ---

  @override
  Future<void> setMonitoredApps(List<String> monitoredAppsMap) async {
    await boxSAS.put("monitoredAppsMap", monitoredAppsMap);
  }

  @override
  Future<List<String>> getMonitoredApps() async {
    final result =
        List<String>.from(boxSAS.get("monitoredAppsMap", defaultValue: []));
    return result;
  }

// -------------X----------------

// --- Save a map of the apps package name and the time that they are monitored ---
  @override
  void setAppTimeMap(Map<String, int> appTimeMap) {
    boxSAS.put("appTimeMap", appTimeMap);
  }

  @override
  Map<String, int> getAppTimeMap() {
    return Map<String, int>.from(
        boxSAS.get("appTimeMap", defaultValue: <String, int>{}));
  }

// -------------X----------------
}
