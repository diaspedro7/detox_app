import 'package:detox_app/data/repositories/home_page_repository.dart';
import 'package:detox_app/data/repositories/time_storage_repository.dart';
import 'package:flutter/material.dart';

class HomePageViewModel extends ChangeNotifier {
  HomePageRepository repository;

  bool isActivated = false;

  HomePageViewModel({required TimeStorageRepository timeStorage})
      : repository = HomePageRepository(timeStorage: timeStorage) {
    isActivated = repository.getLocalActivateAppService();
  }

  void activateAppService(dynamic value) {
    debugPrint(value.toString());
    if (value is bool) {
      repository.setLocalActivateAppService(value);
      debugPrint("Value no hive: ${repository.getLocalActivateAppService()}");
      isActivated = value;
      notifyListeners();
    }
  }
}
