// ignore_for_file: unused_import

import 'package:detox_app/data/repositories/permission_storage_repository.dart';
import 'package:detox_app/data/repositories/selected_apps_storage_repository.dart';
import 'package:detox_app/data/repositories/time_storage_repository.dart';
import 'package:detox_app/data/services/background/flutter_background_service.dart';
import 'package:detox_app/data/services/databases/permission_storage_hive.dart';
import 'package:detox_app/data/services/databases/selected_apps_hive.dart';
import 'package:detox_app/data/services/databases/time_storage_hive.dart';
import 'package:detox_app/features/detox/screens/select_apps/select_apps_page.dart';
import 'package:detox_app/features/permission/screens/verify_permission/verifica_permissao_page.dart';
import 'package:detox_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:provider/provider.dart';

import 'features/detox/screens/home/home_page.dart';
import 'utils/theme/theme.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final service = FlutterBackgroundService();
    final timeStorage = context.read<TimeStorageRepository>();

    // service.invoke('setAsForeground');

    if (state == AppLifecycleState.resumed) {
      debugPrint("Resumed funcionou");
      service.invoke('desligarTimer');
      service.invoke('setAsForeground');

      service.invoke('pauseMonitoring', {'paused': true});
    }

    if (state == AppLifecycleState.paused) {
      debugPrint("Paused funcionou");
      if (timeStorage.getActivateAppService()) {
        timeStorage.resetDailyUsageTime();
        service.invoke('setAsBackground');

        service.invoke('pauseMonitoring', {'paused': false});

        // showNotification();

        // E também envie o evento para o serviço
        // final service = FlutterBackgroundService();
        // service.invoke('appClosed');
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: TAppTheme.lightTheme,
      routes: {
        "/home": (context) => const HomePage(),
        "/select": (context) => const SelectAppsPage(),
      },
      home: //const AlarmPage(packageName: "com.samsung.android.calendar")
          Consumer<PermissionStorageRepository>(
        builder: (_, permissionStorage, __) =>
            permissionStorage.getPermission() == true
                ? const HomePage()
                : const VerificaPermissaoPage(),
      ),
    );
  }
}
