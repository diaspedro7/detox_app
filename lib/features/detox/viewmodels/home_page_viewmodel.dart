import 'package:detox_app/data/repositories/home_page_repository.dart';
import 'package:flutter/material.dart';

class HomePageViewModel extends ChangeNotifier {
  final HomePageRepository _repository = HomePageRepository();

  bool isActivated = false;

  HomePageViewModel() {
    isActivated = _repository.getLocalActivateAppService();
  }

  void activateAppService(dynamic value) {
    debugPrint(value.toString());
    if (value is bool) {
      _repository.setLocalActivateAppService(value);
      debugPrint("Value no hive: ${_repository.getLocalActivateAppService()}");
      isActivated = value;
      notifyListeners();
    }
  }
}
