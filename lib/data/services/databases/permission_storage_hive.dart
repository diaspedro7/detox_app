import 'package:detox_app/data/interfaces/permission_storage_interface.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PermissionStorageHiveDataSource implements IPermissionStorage {
  final boxPS = Hive.box("permissionStorage");

  @override
  void setPermission() {
    boxPS.put("permission", true);
  }

  @override
  bool getPermission() {
    return boxPS.get("permission", defaultValue: false);
  }
}
