import 'dart:async';

import 'package:app_usage/app_usage.dart';
import 'package:detox_app/data/repositories/selected_apps_storage_repository.dart';
import 'package:detox_app/data/repositories/time_storage_repository.dart';
import 'package:detox_app/data/services/background/push_screen_service.dart';
import 'package:detox_app/data/services/databases/selected_apps_hive.dart';
import 'package:detox_app/data/services/databases/time_storage_hive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

final PushScreenService _pushScreenService = PushScreenService();
// Note: This instance is created independently of dependency injection. Be aware if you change the Data Source, you will need to change this instance as well.
final timeStorage =
    TimeStorageRepository(dataSource: TimeStorageHiveDataSource());

// Note: This instance is created independently of dependency injection. Be aware if you change the Data Source, you will need to change this instance as well.
final SelectedAppsStorageRepository _selectedApps =
    SelectedAppsStorageRepository(
        dataSource: SelectedAppsStorageHiveDataSource());

void restartTimer(Timer? timer, ServiceInstance service) async {
  // Cancela timer existente se houver
  timer?.cancel();
  bool isMonitoringPaused = false;

  service.on('pauseMonitoring').listen((event) {
    isMonitoringPaused = event?['paused'] ?? false;
    if (isMonitoringPaused) {
      timer?.cancel();
    }
  });

  timer = Timer.periodic(const Duration(seconds: 5), (timer) {
    service.on('desligarTimer').listen((event) {
      debugPrint("Entrou no desligarTimer");
      service.invoke('setAsForeground');
      timer.cancel();
    });
    debugPrint("Entrou no obter tempo");
    obterTempo(service);
    debugPrint("Timer em execução");
  });
}

Future<void> obterTempo(ServiceInstance service) async {
  try {
    service.invoke('obterTempoPrimeiroPlano', {'isTrue': true});
  } catch (e) {
    debugPrint("Erro ao invocar o obterTempo: $e");
  }
}

Future<void> calculaTempo(String result) async {
  List<String> monitoredApps = await _selectedApps.getMonitoredApps();

  debugPrint("MonitoredApps: $monitoredApps");

  if (result == "") {
    debugPrint("Result vazio");
    return;
  }

  if (monitoredApps.contains(result)) {
    Map<String, int> mapAppsCurrentTime = timeStorage.getMapAppsCurrentTime();
    int currentTime = mapAppsCurrentTime[result] ?? 0;
    debugPrint("CurrentTime: $currentTime");
    debugPrint("Time limit: ${_selectedApps.getAppTimeMap()[result]}");
    if (!(currentTime >= _selectedApps.getAppTimeMap()[result]!)) {
      mapAppsCurrentTime[result] = currentTime + 5;
      timeStorage.setMapAppsCurrentTime(mapAppsCurrentTime);
    }
    if (currentTime >= _selectedApps.getAppTimeMap()[result]!) {
      debugPrint("CurrentTime maior do que o limit");
      Map<String, bool> mapAppsAcrescimActivaded =
          timeStorage.getMapAppAcrescimBool();
      bool thisAppActivated = mapAppsAcrescimActivaded[result] ?? false;

      if (thisAppActivated) {
        debugPrint("ThisAppActivated: $thisAppActivated");
        Map<String, int> mapAppsAcrescimCurrentTime =
            timeStorage.getMapAppAcrescimCurrentTime();
        int currentTimeAcrescim = mapAppsAcrescimCurrentTime[result] ?? 0;
        if (!(currentTimeAcrescim >=
            (timeStorage.getMapAppTimeAcrescimLimit()[result] ?? 0))) {
          mapAppsAcrescimCurrentTime[result] = currentTimeAcrescim + 5;
          timeStorage.setMapAppAcrescimCurrentTime(mapAppsAcrescimCurrentTime);
        }
        debugPrint(
            "CurrentTimeAcrescim: ${mapAppsAcrescimCurrentTime[result]}");
        debugPrint(
            "TimeAcrescimLimit: ${timeStorage.getMapAppTimeAcrescimLimit()[result]}");
        if (currentTimeAcrescim >=
            (timeStorage.getMapAppTimeAcrescimLimit()[result] ?? 0)) {
          debugPrint("CurrentTimeAcrescim maior do que o Acrescimlimit");
          await _pushScreenService.showScreen(result);
        }
      } else {
        debugPrint("Entrou no else");
        await _pushScreenService.showScreen(//service,
            result);
      }
    }
  }
}

Future<void> fetchAppUsage(
    // DateTime dataInicial
    ) async {
  // final List<String> monitoredApps = ['Roblox', 'TikTok', 'Youtube'];

  try {
    DateTime endDate = DateTime.now();
    DateTime startDate = endDate.subtract(const Duration(days: 30));

    // debugPrint("endDate $endDate");
    // debugPrint("StartDate $startDate");

    // await Future.delayed(const Duration(seconds: 2));

    // List<AppUsageInfo> infoList =
    await AppUsage().getAppUsage(startDate, endDate);

    // List<AppUsageInfo> filteredUsage = infoList
    //     .where((info) => monitoredApps.any((app) =>
    //         info.appName.toLowerCase().contains(app.toLowerCase()) ||
    //         info.packageName.toLowerCase().contains(app.toLowerCase())))
    //     .toList();

    // return filteredUsage;
  } on Exception catch (exception) {
    debugPrint("AppUsageException: $exception");
    // return List.empty();
  }
}
