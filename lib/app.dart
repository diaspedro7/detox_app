// ignore_for_file: unused_import

import 'package:detox_app/data/services/permission_storage_hive.dart';
import 'package:detox_app/data/services/time_storage_hive.dart';
import 'package:detox_app/features/detox/screens/add/add_apps_page.dart';
import 'package:detox_app/features/detox/screens/select_apps/select_apps_page.dart';
import 'package:detox_app/features/permission/screens/verify_permission/verifica_permissao_page.dart';
import 'package:detox_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

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

    if (state == AppLifecycleState.paused) {
      debugPrint("Paused funcionou");
      if (getActivateAppService()) {
        service.invoke('setAsBackground');
      }
    }
    if (state == AppLifecycleState.resumed) {
      debugPrint("Resumed funcionou");
      service.invoke('desligarTimer');
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
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      routes: {
        "/home": (context) => const HomePage(),
        "/add": (context) => const AddAppsPage(),
        "/select": (context) => const SelectAppsPage(),
      },
      home: //const AlarmPage(packageName: "com.samsung.android.calendar")
          getPermission() == true
              ? const HomePage()
              : const VerificaPermissaoPage(),
    );
  }
}
