import 'package:detox_app/data/interfaces/time_storage_interface.dart';

class TimeStorageRepository {
  final ITimeStorage _dataSource;

  TimeStorageRepository({required ITimeStorage dataSource})
      : _dataSource = dataSource;

  // --- Saved the current usage time of the monitored apps ---

  void setMapAppsCurrentTime(Map<String, int> appTimeMap) {
    _dataSource.setMapAppsCurrentTime(appTimeMap);
  }

  Map<String, int> getMapAppsCurrentTime() {
    return _dataSource.getMapAppsCurrentTime();
  }

  // -------------X----------------

  // --- Save a map of the monitored apps package name and if they are in acrescim mode ---

  void setMapAppAcrescimBool(
      Map<String, bool> mapPackageNameAndAcrescimActivaded) {
    _dataSource.setMapAppAcrescimBool(mapPackageNameAndAcrescimActivaded);
  }

  Map<String, bool> getMapAppAcrescimBool() {
    return _dataSource.getMapAppAcrescimBool();
  }

  // -------------X----------------

  // --- Save a map of monitored apps package name and the acrescim time

  void setMapAppTimeAcrescimLimit(
      Map<String, int> mapPackageNameAndTimeAcrescim) {
    _dataSource.setMapAppTimeAcrescimLimit(mapPackageNameAndTimeAcrescim);
  }

  Map<String, int> getMapAppTimeAcrescimLimit() {
    return _dataSource.getMapAppTimeAcrescimLimit();
  }

  // -------------X----------------

  void setMapAppAcrescimCurrentTime(
      Map<String, int> mapAppAcrescimCurrentTime) {
    _dataSource.setMapAppAcrescimCurrentTime(mapAppAcrescimCurrentTime);
  }

  Map<String, int> getMapAppAcrescimCurrentTime() {
    return _dataSource.getMapAppAcrescimCurrentTime();
  }

  // --- Save the usage time of the monitored apps ---

  void setMapAppUsageTime(Map<String, int> mapAppUsageTime) {
    _dataSource.setMapAppUsageTime(mapAppUsageTime);
  }

  Map<String, int> getMapAppUsageTime() {
    return _dataSource.getMapAppUsageTime();
  }

  // -------------X----------------

  // --- Save if the background service should activate ---

  void setActivateAppService(bool value) {
    _dataSource.setActivateAppService(value);
  }

  bool getActivateAppService() {
    return _dataSource.getActivateAppService();
  }

  // -------------X----------------

  // --- Save the current day ---

  void setCurrentDay(int day) {
    _dataSource.setCurrentDay(day);
  }

  int getCurrentDay() {
    return _dataSource.getCurrentDay();
  }

  // -------------X----------------

  // --- Reset daily the usage time and acrescim time of the monitored apps ---

  void resetDailyUsageTime() {
    _dataSource.resetDailyUsageTime();
  }

  // -------------X----------------

  void setIsLoading(bool value) {
    _dataSource.setIsLoading(value);
  }

  bool getIsLoading() {
    return _dataSource.getIsLoading();
  }
}
