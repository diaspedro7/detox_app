import 'package:detox_app/app.dart';
import 'package:detox_app/data/services/background/flutter_background_service.dart';
import 'package:detox_app/data/services/background/push_screen_service.dart';
import 'package:detox_app/features/detox/viewmodels/app_viewmodel.dart';
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

  runApp(ChangeNotifierProvider(
      create: (_) => AppViewModel(), child: const MyApp()));

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
        calculaTempo(resultText, service);

        debugPrint("Result: $resultText");
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
