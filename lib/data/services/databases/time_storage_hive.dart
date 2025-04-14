import 'package:detox_app/data/interfaces/time_storage_interface.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TimeStorageHiveDataSource implements ITimeStorage {
  final boxTempo = Hive.box("obterTempoBackground");

// --- Saved the current usage time of the monitored apps ---

  @override
  void setMapAppsCurrentTime(Map<String, int> appTimeMap) {
    boxTempo.put('mapAppsCurrentTimeKey', appTimeMap);
  }

  @override
  Map<String, int> getMapAppsCurrentTime() {
    return Map<String, int>.from(
        boxTempo.get('mapAppsCurrentTimeKey', defaultValue: {}));
  }

// -------------X----------------

// --- Save a map of the monitored apps package name and if they are in acrescim mode ---

  @override
  void setMapAppAcrescimBool(
      Map<String, bool> mapPackageNameAndAcrescimActivaded) {
    boxTempo.put("mapAppAcrescimBoolKey", mapPackageNameAndAcrescimActivaded);
  }

  @override
  Map<String, bool> getMapAppAcrescimBool() {
    return Map<String, bool>.from(
        boxTempo.get("mapAppAcrescimBoolKey", defaultValue: <String, bool>{}));
  }

// -------------X----------------

// --- Save a map of monitored apps package name and the acrescim time

  @override
  void setMapAppTimeAcrescimLimit(
      Map<String, int> mapPackageNameAndTimeAcrescim) {
    boxTempo.put("mapAppTimeAcrescimKey", mapPackageNameAndTimeAcrescim);
  }

  @override
  Map<String, int> getMapAppTimeAcrescimLimit() {
    return Map<String, int>.from(
        boxTempo.get("mapAppTimeAcrescimKey", defaultValue: <String, int>{}));
  }

// -------------X----------------

  @override
  void setMapAppAcrescimCurrentTime(
      Map<String, int> mapAppAcrescimCurrentTime) {
    boxTempo.put("mapAppAcrescimCurrentTimeKey", mapAppAcrescimCurrentTime);
  }

  @override
  Map<String, int> getMapAppAcrescimCurrentTime() {
    return Map<String, int>.from(boxTempo
        .get("mapAppAcrescimCurrentTimeKey", defaultValue: <String, int>{}));
  }

// --- Save the usage time of the monitored apps ---

  @override
  void setMapAppUsageTime(Map<String, int> mapAppUsageTime) {
    boxTempo.put("mapAppUsageTimeKey", mapAppUsageTime);
  }

  @override
  Map<String, int> getMapAppUsageTime() {
    return Map<String, int>.from(
        boxTempo.get("mapAppUsageTimeKey", defaultValue: <String, int>{}));
  }

// -------------X----------------

// --- Save if the background service should activate ---

  @override
  void setActivateAppService(bool value) {
    boxTempo.put("activateAppServiceKey", value);
  }

  @override
  bool getActivateAppService() {
    return boxTempo.get("activateAppServiceKey", defaultValue: false);
  }

// -------------X----------------

// --- Save the current day ---

  @override
  void setCurrentDay(int day) {
    boxTempo.put("currentDayKey", day);
  }

  @override
  int getCurrentDay() {
    return boxTempo.get("currentDayKey", defaultValue: 0);
  }

// -------------X----------------

// --- Reset daily the usage time and acrescim time of the monitored apps ---

  @override
  void resetDailyUsageTime() {
    debugPrint("CurrentDay: ${getCurrentDay()}");
    if (DateTime.now().day != getCurrentDay()) {
      setMapAppsCurrentTime(<String, int>{});
      setMapAppAcrescimCurrentTime(<String, int>{});
      setMapAppTimeAcrescimLimit(<String, int>{});
      setCurrentDay(DateTime.now().day);
    }
    debugPrint("Current map Usage Time: ${getMapAppsCurrentTime()}");
  }

// -------------X----------------

  @override
  void setIsLoading(bool value) {
    boxTempo.put("isLoadingKey", value);
  }

  @override
  bool getIsLoading() {
    return boxTempo.get("isLoadingKey", defaultValue: false);
  }
}
