import 'package:flutter/material.dart';

class PermissionViewModel extends ChangeNotifier {
  bool batteryPermission = false;
  bool overlayPermission = false;
  bool acessPermission = false;

  void setBatteryPermission(bool value) {
    batteryPermission = value;
    notifyListeners();
  }

  void setOverlayPermission(bool value) {
    overlayPermission = value;
    notifyListeners();
  }

  void setAcessPermission(bool value) {
    acessPermission = value;
    notifyListeners();
  }

  bool isBothPermissionsAccepted() {
    //TODO: MAKE THE FETCHAPPUSAGE BE A BOOLEAN FUNCTION AND ADD HIM HERE
    return batteryPermission && overlayPermission;
  }
}
