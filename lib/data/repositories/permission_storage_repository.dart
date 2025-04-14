import 'package:detox_app/data/interfaces/permission_storage_interface.dart';
import 'package:detox_app/data/services/databases/permission_storage_hive.dart';

class PermissionStorageRepository {
  final IPermissionStorage _dataSource;

  PermissionStorageRepository(
      {required PermissionStorageHiveDataSource dataSource})
      : _dataSource = dataSource;

  void setPermission() {
    _dataSource.setPermission();
  }

  bool getPermission() {
    return _dataSource.getPermission();
  }
}
