abstract class ITimeStorage {
  // --- Saved the current usage time of the monitored apps ---

  void setMapAppsCurrentTime(Map<String, int> appTimeMap);

  Map<String, int> getMapAppsCurrentTime();

  // --- Save a map of the monitored apps package name and if they are in acrescim mode ---

  void setMapAppAcrescimBool(
      Map<String, bool> mapPackageNameAndAcrescimActivaded);

  Map<String, bool> getMapAppAcrescimBool();

  // --- Save a map of monitored apps package name and the acrescim time
  void setMapAppTimeAcrescimLimit(
      Map<String, int> mapPackageNameAndTimeAcrescim);

  Map<String, int> getMapAppTimeAcrescimLimit();

  void setMapAppAcrescimCurrentTime(Map<String, int> mapAppAcrescimCurrentTime);

  Map<String, int> getMapAppAcrescimCurrentTime();

  // --- Save the usage time of the monitored apps ---
  void setMapAppUsageTime(Map<String, int> mapAppUsageTime);

  Map<String, int> getMapAppUsageTime();

  // --- Save if the background service should activate ---

  void setActivateAppService(bool value);

  bool getActivateAppService();

  // --- Save the current day ---

  void setCurrentDay(int day);

  int getCurrentDay();

  // --- Reset daily the usage time and acrescim time of the monitored apps ---

  void resetDailyUsageTime();

  void setIsLoading(bool value);

  bool getIsLoading();
}
