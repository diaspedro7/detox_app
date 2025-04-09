import 'package:detox_app/data/services/selected_apps_hive.dart';
import 'package:detox_app/data/services/time_storage_hive.dart';

class AppDetailsPageRepository {
  Map<String, int> getLocalAppTimeMap() {
    return getAppTimeMap();
  }

  void setLocalAppTimeMap(Map<String, int> appTimeMap) {
    setAppTimeMap(appTimeMap);
  }

  Future<void> deleteApp(String packageName) async {
    //Turn false
    Map<String, bool> selectedAppsMap = getSelectedAppsMap();
    selectedAppsMap[packageName] = false;
    setSelectedAppsMap(selectedAppsMap);

    //Remove from monitored apps list
    List<String> monitoredAppsList = await getMonitoredApps();
    monitoredAppsList.remove(packageName);
    await setMonitoredApps(monitoredAppsList);

    //Remove from app time map
    Map<String, int> appTimeMap = getAppTimeMap();
    appTimeMap.remove(packageName);
    setAppTimeMap(appTimeMap);

    //remove from current usage time map
    Map<String, int> currentTimeMap = getMapAppsCurrentTime();
    currentTimeMap.remove(packageName);
    setMapAppsCurrentTime(currentTimeMap);

    //remove from acrescim mode bool map
    Map<String, bool> acrecismModeMap = getMapAppAcrescimBool();
    acrecismModeMap.remove(packageName);
    setMapAppAcrescimBool(acrecismModeMap);

    //remove from acrescim mode time map
    Map<String, int> acrecismTimeMap = getMapAppTimeAcrescimLimit();
    acrecismTimeMap.remove(packageName);
    setMapAppTimeAcrescimLimit(acrecismTimeMap);

    //remove from acrescim current time map
    Map<String, int> acrecismCurrentTimeMap = getMapAppAcrescimCurrentTime();
    acrecismCurrentTimeMap.remove(packageName);
    setMapAppAcrescimCurrentTime(acrecismCurrentTimeMap);

    //remove from monitored apps usage time
    Map<String, int> monitoredAppsUsageTime = getMapAppUsageTime();
    monitoredAppsUsageTime.remove(packageName);
    setMapAppUsageTime(monitoredAppsUsageTime);
  }
}
