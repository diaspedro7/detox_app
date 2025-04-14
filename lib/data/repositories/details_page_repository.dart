import 'package:detox_app/data/repositories/selected_apps_storage_repository.dart';
import 'package:detox_app/data/repositories/time_storage_repository.dart';

class AppDetailsPageRepository {
  final TimeStorageRepository timeStorage;
  final SelectedAppsStorageRepository selectedApps;

  AppDetailsPageRepository(
      {required this.timeStorage, required this.selectedApps});

  Map<String, int> getLocalAppTimeMap() {
    return selectedApps.getAppTimeMap();
  }

  void setLocalAppTimeMap(Map<String, int> appTimeMap) {
    selectedApps.setAppTimeMap(appTimeMap);
  }

  Future<void> deleteApp(String packageName) async {
    //Turn false
    Map<String, bool> selectedAppsMap = selectedApps.getSelectedAppsMap();
    selectedAppsMap[packageName] = false;
    selectedApps.setSelectedAppsMap(selectedAppsMap);

    //Remove from monitored apps list
    List<String> monitoredAppsList = await selectedApps.getMonitoredApps();
    monitoredAppsList.remove(packageName);
    await selectedApps.setMonitoredApps(monitoredAppsList);

    //Remove from app time map
    Map<String, int> appTimeMap = selectedApps.getAppTimeMap();
    appTimeMap.remove(packageName);
    selectedApps.setAppTimeMap(appTimeMap);

    //remove from current usage time map
    Map<String, int> currentTimeMap = timeStorage.getMapAppsCurrentTime();
    currentTimeMap.remove(packageName);
    timeStorage.setMapAppsCurrentTime(currentTimeMap);

    //remove from acrescim mode bool map
    Map<String, bool> acrecismModeMap = timeStorage.getMapAppAcrescimBool();
    acrecismModeMap.remove(packageName);
    timeStorage.setMapAppAcrescimBool(acrecismModeMap);

    //remove from acrescim mode time map
    Map<String, int> acrecismTimeMap = timeStorage.getMapAppTimeAcrescimLimit();
    acrecismTimeMap.remove(packageName);
    timeStorage.setMapAppTimeAcrescimLimit(acrecismTimeMap);

    //remove from acrescim current time map
    Map<String, int> acrecismCurrentTimeMap =
        timeStorage.getMapAppAcrescimCurrentTime();
    acrecismCurrentTimeMap.remove(packageName);
    timeStorage.setMapAppAcrescimCurrentTime(acrecismCurrentTimeMap);

    //remove from monitored apps usage time
    Map<String, int> monitoredAppsUsageTime = timeStorage.getMapAppUsageTime();
    monitoredAppsUsageTime.remove(packageName);
    timeStorage.setMapAppUsageTime(monitoredAppsUsageTime);
  }
}
