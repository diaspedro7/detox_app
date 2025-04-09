import 'package:detox_app/app.dart';
import 'package:detox_app/data/services/background/flutter_background_service.dart';
import 'package:detox_app/data/services/background/notification_on_kill_service.dart';
import 'package:detox_app/features/detox/viewmodels/circular_slide_viewmodel.dart';
import 'package:detox_app/features/detox/viewmodels/details_page_viewmodel.dart';
import 'package:detox_app/features/detox/viewmodels/home_page_viewmodel.dart';
import 'package:detox_app/features/detox/viewmodels/select_apps_viewmodel.dart';
import 'package:detox_app/features/detox/viewmodels/app_viewmodel.dart';
import 'package:detox_app/features/permission/viewmodel/permission_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'data/services/background/calculate_time_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();

  await Hive.initFlutter();
  await Hive.openBox("obterTempoBackground");
  await Hive.openBox("permissionStorage");
  await Hive.openBox("selectedAppsStorage");

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => AppViewModel()),
    ChangeNotifierProvider(create: (_) => PermissionViewModel()),
    ChangeNotifierProvider(create: (_) => SelectAppsPageViewModel()),
    ChangeNotifierProvider(create: (_) => CircularSlideViewModel()),
    ChangeNotifierProvider(create: (_) => HomePageViewModel()),
    ChangeNotifierProvider(create: (_) => AppDetailsPageViewModel()),
  ], child: const MyApp()));

  NotifOnKill.toggleNotifOnKill(true);

  final service = FlutterBackgroundService();

  service.on('telaJaExibida').listen((event) {
    debugPrint("Entrou no servicao");
    if (event == null || event['valor'] == true) {
      debugPrint("Inicializou o servico");

      service.invoke('telaJaExibida', {'valor': false});
    }
  });

  service.on('obterTempoPrimeiroPlano').listen((event) async {
    debugPrint("Entrou no obterTempoPrimeiroPlano");
    if (event != null) {
      bool varBool = event["isTrue"];
      if (varBool) {
        var channel = const MethodChannel("appsTimeUsage");

        String resultText = await channel.invokeMethod('getTime');
        debugPrint("Esse Result1: $resultText");

        calculaTempo(resultText);

        debugPrint("Esse Result2: $resultText");
      }
    }
  });

  // service.on('entrarDireto').listen((event) async {
  //   if (event != null) {
  //     bool varBool = event["isTrue"];
  //     if (varBool) {
  //       var channel = const MethodChannel("appsTimeUsage");

  //       String resultText = await channel.invokeMethod('getTime');
  //       exibirTela(service, resultText);
  //     }
  //   }
  // });
}
