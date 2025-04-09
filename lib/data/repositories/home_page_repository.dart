import 'package:detox_app/data/services/time_storage_hive.dart';

class HomePageRepository {
  bool getLocalActivateAppService() {
    return getActivateAppService();
  }

  void setLocalActivateAppService(bool value) {
    setActivateAppService(value);
  }
}
