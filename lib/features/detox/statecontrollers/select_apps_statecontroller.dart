import 'package:flutter/material.dart';

class SelectAppsPageStatecontroller extends ChangeNotifier {
  Map<String, bool> selectedAppsMap = {};

  void initializeSelectedAppsMap(List<String> appsList) {
    selectedAppsMap = {for (var app in appsList) app: false};
    notifyListeners();
  }

  void toggleAppSelection(String app) {
    //debugPrint("SelectedAppsMap: $selectedAppsMap");
    if (selectedAppsMap.isNotEmpty) {
      selectedAppsMap[app] = !selectedAppsMap[app]!;
      notifyListeners();
    }
  }

  void mapClear() {
    selectedAppsMap.clear();
    notifyListeners();
  }
}
