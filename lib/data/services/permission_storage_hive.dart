import 'package:hive_flutter/hive_flutter.dart';

final boxPS = Hive.box("permissionStorage");

void setPermission() {
  boxPS.put("permission", true);
}

bool getPermission() {
  return boxPS.get("permission", defaultValue: false);
}
