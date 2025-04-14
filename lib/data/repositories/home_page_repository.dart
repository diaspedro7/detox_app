import 'package:detox_app/data/repositories/time_storage_repository.dart';

class HomePageRepository {
  final TimeStorageRepository timeStorage;

  HomePageRepository({required this.timeStorage});

  bool getLocalActivateAppService() {
    return timeStorage.getActivateAppService();
  }

  void setLocalActivateAppService(bool value) {
    timeStorage.setActivateAppService(value);
  }
}
