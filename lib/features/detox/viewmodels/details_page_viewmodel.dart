import 'package:detox_app/data/repositories/details_page_repository.dart';
import 'package:detox_app/data/repositories/selected_apps_storage_repository.dart';
import 'package:detox_app/data/repositories/time_storage_repository.dart';
import 'package:flutter/material.dart';

class AppDetailsPageViewModel extends ChangeNotifier {
  final AppDetailsPageRepository _repository;

  int limitTimeMin = 0;

  AppDetailsPageViewModel(
      {required SelectedAppsStorageRepository selectedApps,
      required TimeStorageRepository timeStorage})
      : _repository = AppDetailsPageRepository(
            selectedApps: selectedApps, timeStorage: timeStorage);

  int getLimitTime(String packageName) {
    try {
      limitTimeMin =
          (_repository.getLocalAppTimeMap()[packageName]! / 60).toInt();
      return limitTimeMin;
    } catch (e) {
      return 0;
    }
  }

  void setLimitTime(String packageName, int value) {
    try {
      Map<String, int> mapAppTime = _repository.getLocalAppTimeMap();
      mapAppTime[packageName] = value;
      _repository.setLocalAppTimeMap(mapAppTime);
    } catch (e) {
      debugPrint("Error in setLimitTime: $e");
    } finally {
      notifyListeners();
    }
  }

  void deleteApp(String packageName) async {
    try {
      await _repository.deleteApp(packageName);
    } catch (e) {
      debugPrint("Error in deleteApp: $e");
    }
  }
}
