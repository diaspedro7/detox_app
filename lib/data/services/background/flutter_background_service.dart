import 'dart:async';
import 'dart:ui';
import 'package:detox_app/data/services/background/calculate_time_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

// final CalculateTimeService _calculateTimeService = CalculateTimeService();

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      autoStartOnBoot: true,
      isForegroundMode: true,
      foregroundServiceNotificationId: 46,
      initialNotificationTitle: 'Stay Mindful',
      initialNotificationContent: 'Taking care of your digital health.',
    ),
    iosConfiguration: IosConfiguration(),
  );

  await service.startService();
  // Start the service
  bool isStarted = await service.startService();
  if (isStarted) {
    debugPrint("Service initialized successfully");
  } else {
    debugPrint("Failed to start service");
  }
  service.invoke('telaJaExibida', {'valor': false});
  debugPrint("Servico has started");
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Register plugins in the service Isolate
  DartPluginRegistrant.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  // bool telaJaExibida = false;

  // service.on('telaJaExibida').listen((event) {
  //   debugPrint("Entrou no servico");

  //   if (event != null) {
  //     debugPrint("Event nao eh null :)");
  //     telaJaExibida = event['valor'];
  //     debugPrint("TelaJaExibida: $telaJaExibida");
  //   } else {
  //     telaJaExibida = false;
  //   }
  // });

  if (service is AndroidServiceInstance) {
    //When app is in foreground set as background
    service.on('setAsForeground').listen(
      (event) {
        service.setAsBackgroundService();
      },
    );

    //When app is in background set as foreground
    service.on('setAsBackground').listen((event) async {
      service.setAsForegroundService();
      foregroundServiceFunction(service);
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });
}

void foregroundServiceFunction(ServiceInstance service) {
  try {
    debugPrint("Entered Foreground");
    Timer? timer;

    // _calculateTimeService.restartTimer(timer, service);
    restartTimer(timer, service);

    debugPrint("Foreground continued!!!");
  } catch (e) {
    debugPrint("Foreground error: $e");
  }
}
