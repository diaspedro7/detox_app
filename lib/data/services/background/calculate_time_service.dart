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
  List<String> monitoredApps = getSelectedAppsMap()
      .entries
      .where((entry) => entry.value) // Filtra apenas os valores `true`
      .map((entry) => entry.key) // Pega as chaves correspondentes
      .toList();

  debugPrint("MonitoredApps: $monitoredApps");

  if (monitoredApps.contains(result)) {
    //If the last apps used is in the list
    int tempo = getTempoSalvo(); //get the last saved time
    tempo = tempo + 5; //add the time has passed
    debugPrint("TempoSalvo: $tempo");
    setTempoSalvo(tempo); //save the new time that has passed
    debugPrint("Tempo de intervalo: ${getTempoDeIntervaloSomado()}");
    if (tempo >= getAppTimeMap()[result]!) {
      //if (tempo >= getTempoDeIntervaloSomado()) { //if the time has passed is greater than the estipulated time
      //TODO: Add the logic to what is gonna do after the time has finished
      debugPrint("Entrou no passar o intervalo");
      setTempoDeIntervaloSomado(tempo +
          getTempoTemporizador()); //add the interval time and the time that has passed
      exibirTela(service); //go to the alarm screen
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
