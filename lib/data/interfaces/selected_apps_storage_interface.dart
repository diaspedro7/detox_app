abstract class ISelectedAppsStorage {
// --- Save the all apps package name and if their are selected or not ---

  void setSelectedAppsMap(Map<String, bool> selectedAppsMap);

  Map<String, bool> getSelectedAppsMap();

// -------------X----------------

// --- Save the apps package name that are monitored ---

  Future<void> setMonitoredApps(List<String> monitoredAppsMap);

  Future<List<String>> getMonitoredApps();

// -------------X----------------

// --- Save a map of the apps package name and the time that they are monitored ---
  void setAppTimeMap(Map<String, int> appTimeMap);

  Map<String, int> getAppTimeMap();
}
