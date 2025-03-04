import 'package:hive_flutter/hive_flutter.dart';

final boxSAS = Hive.box("selectedAppsStorage");

void setSelectedAppsMap(Map<String, bool> selectedAppsMap) {
  boxSAS.put("selectedAppsMap", selectedAppsMap);
}

Map<String, bool> getSelectedAppsMap() {
  return Map<String, bool>.from(
      boxSAS.get("selectedAppsMap", defaultValue: <String, bool>{}));
}

void setMonitoredApps(List<String> monitoredAppsMap) {
  boxSAS.put("monitoredAppsMap", monitoredAppsMap);
}

List<String> getMonitoredApps() {
  return List<String>.from(boxSAS.get("monitoredAppsMap", defaultValue: []));
}

void setAppTimeMap(Map<String, int> appTimeMap) {
  boxSAS.put("appTimeMap", appTimeMap);
}

Map<String, int> getAppTimeMap() {
  return Map<String, int>.from(
      boxSAS.get("appTimeMap", defaultValue: <String, int>{}));
}
