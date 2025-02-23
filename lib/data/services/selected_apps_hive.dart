import 'package:hive_flutter/hive_flutter.dart';

final boxSAS = Hive.box("selectedAppsStorage");

void setSelectedAppsMap(Map<String, bool> selectedAppsMap) {
  boxSAS.put("selectedAppsMap", selectedAppsMap);
}

Map<String, bool> getSelectedAppsMap() {
  return Map<String, bool>.from(
      boxSAS.get("selectedAppsMap", defaultValue: <String, bool>{}));
}
