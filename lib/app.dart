import 'package:detox_app/data/services/permission_storage_hive.dart';
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
      service.invoke('setAsBackground');
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
      home: getPermission() == true
          ? const HomePage()
          : const VerificaPermissaoPage(),
    );
  }
}
