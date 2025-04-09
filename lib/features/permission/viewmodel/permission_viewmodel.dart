import 'package:flutter/material.dart';

class PermissionViewModel extends ChangeNotifier {
  bool batteryPermission = false;
  bool overlayPermission = false;

  void setBatteryPermission(bool value) {
    batteryPermission = value;
    notifyListeners();
  }

  void setOverlayPermission(bool value) {
    overlayPermission = value;
    notifyListeners();
  }

  bool isBothPermissionsAccepted() {
    return batteryPermission && overlayPermission;
  }
}
