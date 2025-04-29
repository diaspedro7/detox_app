import 'package:detox_app/app.dart';
import 'package:detox_app/data/repositories/permission_storage_repository.dart';
import 'package:detox_app/data/repositories/selected_apps_storage_repository.dart';
import 'package:detox_app/data/repositories/time_storage_repository.dart';
import 'package:detox_app/data/services/background/flutter_background_service.dart';
import 'package:detox_app/data/services/background/notification_on_kill_service.dart';
import 'package:detox_app/data/services/databases/permission_storage_hive.dart';
import 'package:detox_app/data/services/databases/selected_apps_hive.dart';
import 'package:detox_app/data/services/databases/time_storage_hive.dart';
import 'package:detox_app/features/detox/viewmodels/circular_slide_viewmodel.dart';
import 'package:detox_app/features/detox/viewmodels/details_page_viewmodel.dart';
import 'package:detox_app/features/detox/viewmodels/home_page_viewmodel.dart';
import 'package:detox_app/features/detox/viewmodels/select_apps_viewmodel.dart';
import 'package:detox_app/features/detox/viewmodels/app_viewmodel.dart';
import 'package:detox_app/features/permission/viewmodel/permission_viewmodel.dart';
import 'package:detox_app/utils/constants/colors.dart';
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

// final CalculateTimeService calculateTimeService = CalculateTimeService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();

  await Hive.initFlutter();
  await Hive.openBox("obterTempoBackground");
  await Hive.openBox("permissionStorage");
  await Hive.openBox("selectedAppsStorage");

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: TColors.dark,
    statusBarColor: TColors.dark,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  runApp(MultiProvider(providers: [
    Provider(create: (_) => SelectedAppsStorageHiveDataSource()),
    ProxyProvider<SelectedAppsStorageHiveDataSource,
            SelectedAppsStorageRepository>(
        update: (_, dataSource, __) =>
            SelectedAppsStorageRepository(dataSource: dataSource)),
    Provider(create: (_) => PermissionStorageHiveDataSource()),
    ProxyProvider<PermissionStorageHiveDataSource, PermissionStorageRepository>(
        update: (_, dataSource, __) =>
            PermissionStorageRepository(dataSource: dataSource)),
    Provider(create: (_) => TimeStorageHiveDataSource()),
    ProxyProvider<TimeStorageHiveDataSource, TimeStorageRepository>(
        update: (_, dataSource, __) =>
            TimeStorageRepository(dataSource: dataSource)),
    ChangeNotifierProvider(
        create: (_) => AppViewModel(
            selectedApps: _.read<SelectedAppsStorageRepository>(),
            timeStorage: _.read<TimeStorageRepository>())),
    ChangeNotifierProvider(create: (_) => PermissionViewModel()),
    ChangeNotifierProvider(create: (_) => SelectAppsPageViewModel()),
    ChangeNotifierProvider(create: (_) => CircularSlideViewModel()),
    ChangeNotifierProvider(
        create: (_) =>
            HomePageViewModel(timeStorage: _.read<TimeStorageRepository>())),
    ChangeNotifierProvider(
        create: (_) => AppDetailsPageViewModel(
            selectedApps: _.read<SelectedAppsStorageRepository>(),
            timeStorage: _.read<TimeStorageRepository>())),
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
