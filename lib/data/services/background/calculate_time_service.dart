import 'dart:async';

import 'package:app_usage/app_usage.dart';
import 'package:detox_app/data/services/background/push_screen_service.dart';
import 'package:detox_app/data/services/selected_apps_hive.dart';
import 'package:detox_app/data/services/time_storage_hive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

void restartTimer(ServiceInstance service, Timer? timer) async {
  timer = Timer.periodic(const Duration(seconds: 5), (timer) {
    service.on('desligarTimer').listen((event) {
      debugPrint("Entrou no desligarTimer");

      timer.cancel();
    });

    obterTempo(service);
    debugPrint("Entrou no timer");
  });
}

Future<void> obterTempo(ServiceInstance service) async {
  try {
    service.invoke('obterTempoPrimeiroPlano', {'isTrue': true});
  } catch (e) {
    debugPrint("Erro ao invocar o obterTempo: $e");
  }
}

Future<void> calculaTempo(
    String result, FlutterBackgroundService service) async {
  List<String> monitoredApps = await getMonitoredApps();

  debugPrint("MonitoredApps: $monitoredApps");

  if (monitoredApps.contains(result)) {
    Map<String, int> mapAppsCurrentTime = getMapAppsCurrentTime();
    int currentTime = mapAppsCurrentTime[result] ?? 0;
    debugPrint("CurrentTime: $currentTime");
    debugPrint("Time limit: ${getAppTimeMap()[result]}");
    if (!(currentTime >= getAppTimeMap()[result]!)) {
      mapAppsCurrentTime[result] = currentTime + 5;
      setMapAppsCurrentTime(mapAppsCurrentTime);
    }
    if (currentTime >= getAppTimeMap()[result]!) {
      debugPrint("CurrentTime maior do que o limit");
      Map<String, bool> mapAppsAcrescimActivaded = getMapAppAcrescimBool();
      bool thisAppActivated = mapAppsAcrescimActivaded[result] ?? false;

      if (thisAppActivated) {
        debugPrint("ThisAppActivated: $thisAppActivated");
        Map<String, int> mapAppsAcrescimCurrentTime =
            getMapAppAcrescimCurrentTime();
        int currentTimeAcrescim = mapAppsAcrescimCurrentTime[result] ?? 0;
        if (!(currentTimeAcrescim >= getMapAppTimeAcrescimLimit()[result]!)) {
          mapAppsAcrescimCurrentTime[result] = currentTimeAcrescim + 5;
          setMapAppAcrescimCurrentTime(mapAppsAcrescimCurrentTime);
        }
        debugPrint(
            "CurrentTimeAcrescim: ${mapAppsAcrescimCurrentTime[result]}");
        debugPrint(
            "TimeAcrescimLimit: ${getMapAppTimeAcrescimLimit()[result]}");
        if (currentTimeAcrescim >= getMapAppTimeAcrescimLimit()[result]!) {
          debugPrint("CurrentTimeAcrescim maior do que o Acrescimlimit");
          await exibirTela(service, result);
        }
      } else {
        debugPrint("Entrou no else");
        await exibirTela(service, result);
      }
    }
  }
}

Future<List<AppUsageInfo>> fetchAppUsage(DateTime dataInicial) async {
  final List<String> monitoredApps = ['Roblox', 'TikTok', 'Youtube'];

  try {
    DateTime endDate = DateTime.now();
    DateTime startDate = endDate.subtract(const Duration(days: 30));

    debugPrint("endDate $endDate");
    debugPrint("StartDate $startDate");

    await Future.delayed(const Duration(seconds: 2));

    List<AppUsageInfo> infoList =
        await AppUsage().getAppUsage(startDate, endDate);

    List<AppUsageInfo> filteredUsage = infoList
        .where((info) => monitoredApps.any((app) =>
            info.appName.toLowerCase().contains(app.toLowerCase()) ||
            info.packageName.toLowerCase().contains(app.toLowerCase())))
        .toList();

    return filteredUsage;
  } on Exception catch (exception) {
    debugPrint("AppUsageException: $exception");
    return List.empty();
  }
}
