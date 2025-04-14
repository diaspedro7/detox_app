import 'package:detox_app/data/interfaces/selected_apps_storage_interface.dart';

class SelectedAppsStorageRepository {
  final ISelectedAppsStorage _dataSource;

  SelectedAppsStorageRepository({required ISelectedAppsStorage dataSource})
      : _dataSource = dataSource;

  void setSelectedAppsMap(Map<String, bool> selectedAppsMap) {
    _dataSource.setSelectedAppsMap(selectedAppsMap);
  }

  Map<String, bool> getSelectedAppsMap() {
    return _dataSource.getSelectedAppsMap();
  }

  Future<void> setMonitoredApps(List<String> monitoredAppsMap) async {
    await _dataSource.setMonitoredApps(monitoredAppsMap);
  }

  Future<List<String>> getMonitoredApps() async {
    return await _dataSource.getMonitoredApps();
  }

  void setAppTimeMap(Map<String, int> appTimeMap) {
    _dataSource.setAppTimeMap(appTimeMap);
  }

  Map<String, int> getAppTimeMap() {
    return _dataSource.getAppTimeMap();
  }
}
