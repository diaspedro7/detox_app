import 'dart:async';
import 'dart:ui';
import 'package:detox_app/data/services/background/calculate_time_service.dart';
import 'package:detox_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      autoStartOnBoot: true,
      isForegroundMode: true,
      foregroundServiceNotificationId: 888,
      initialNotificationTitle: 'Stay Mindful',
      initialNotificationContent: 'Taking care of your digital health.',
    ),
    iosConfiguration: IosConfiguration(),
  );

  await service.startService();
  // Inicia o serviço
  bool isStarted = await service.startService();
  if (isStarted) {
    debugPrint("Serviço inicializado com sucesso");
  } else {
    debugPrint("Falha ao iniciar o serviço");
  }
  service.invoke('telaJaExibida', {'valor': false});
  debugPrint("Servico startou");
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant
      .ensureInitialized(); // Registra plugins no Isolate do serviço
  WidgetsFlutterBinding.ensureInitialized();
  bool telaJaExibida = false;

  service.on('telaJaExibida').listen((event) {
    debugPrint("Entrou no servico");

    if (event != null) {
      debugPrint("Event nao eh null :)");
      telaJaExibida = event['valor'];
      debugPrint("TelaJaExibida: $telaJaExibida");
    } else {
      telaJaExibida = false;
    }
  });

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen(
      (event) {
        service.setAsBackgroundService();
      },
    );

    service.on('setAsBackground').listen((event) async {
      service.setAsForegroundService();
      debugPrint("Background rooooodando!---");
      try {
        debugPrint("Entrou no background");
        // if (telaJaExibida) {
        //   debugPrint("Entrou direto");
        //   service.invoke('entrarDireto', {'isTrue': true});
        // }
        // else {
        Timer? timer;

        //await obterTempo(service);
        debugPrint("Entrou no else");
        restartTimer(timer, service);
        //}

        debugPrint("O background continuou!!!");
      } catch (e) {
        debugPrint("Erro no background: $e");
      }
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });
}
