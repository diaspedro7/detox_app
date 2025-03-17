import 'package:detox_app/data/services/time_storage_hive.dart';
import 'package:flutter/material.dart';

class HomePageStateController extends ChangeNotifier {
  bool isActivated = getActivateAppService();

  void activateAppService(dynamic value) {
    debugPrint(value.toString());
    if (value is bool) {
      setActivateAppService(value);
      debugPrint("Value no hive: ${getActivateAppService()}");
      isActivated = value;
      notifyListeners();
    }
  }
}
