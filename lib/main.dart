import 'package:detox_app/app.dart';
import 'package:detox_app/data/services/background/flutter_background_service.dart';
import 'package:detox_app/data/services/background/push_screen_service.dart';
import 'package:detox_app/features/detox/statecontrollers/circular_slide_statecontroller.dart';
import 'package:detox_app/features/detox/statecontrollers/select_apps_statecontroller.dart';
import 'package:detox_app/features/detox/viewmodels/app_viewmodel.dart';
import 'package:detox_app/features/permission/statecontroller/permission_statecontroller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'data/services/background/calculate_time_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();

  await Hive.initFlutter();
  await Hive.openBox("obterTempoBackground");
  await Hive.openBox("permissionStorage");
  await Hive.openBox("selectedAppsStorage");

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => AppViewModel()),
    ChangeNotifierProvider(create: (_) => PermissionStateController()),
    ChangeNotifierProvider(create: (_) => SelectAppsPageStatecontroller()),
    ChangeNotifierProvider(create: (_) => CircularSlideStateController()),
  ], child: const MyApp()));

  final service = FlutterBackgroundService();

  service.on('telaJaExibida').listen((event) {
    debugPrint("Entrou no servicao");
    if (event == null || event['valor'] == true) {
      debugPrint("Inicializou o servico");

      service.invoke('telaJaExibida', {'valor': false});
    }
  });

  service.on('obterTempoPrimeiroPlano').listen((event) async {
    if (event != null) {
      bool varBool = event["isTrue"];
      if (varBool) {
        var channel = const MethodChannel("appsTimeUsage");

        String resultText = await channel.invokeMethod('getTime');
        debugPrint("Esse Result1: $resultText");

        calculaTempo(resultText, service);

        debugPrint("Esse Result2: $resultText");
      }
    }
  });

  service.on('entrarDireto').listen((event) async {
    if (event != null) {
      bool varBool = event["isTrue"];
      if (varBool) {
        exibirTela(service);
      }
    }
  });
}
