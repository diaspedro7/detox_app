import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:detox_app/data/repositories/time_storage_repository.dart';
import 'package:detox_app/data/services/databases/time_storage_hive.dart';
import 'package:detox_app/features/detox/models/app_model.dart';
import 'package:detox_app/features/detox/screens/alarm/alarm_page.dart';
import 'package:detox_app/features/detox/viewmodels/app_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:detox_app/main.dart';
import 'package:provider/provider.dart';

class PushScreenService {
  // Note: This instance is created independently of dependency injection. Be aware if you change the Data Source, you will need to change this instance as well.
  final timeStorage =
      TimeStorageRepository(dataSource: TimeStorageHiveDataSource());

  Future<void> showScreen(String packageName) async {
    if (timeStorage.getIsLoading()) return;

    try {
      timeStorage.setIsLoading(true);
      AppModel? app = await _returnAppfromName(packageName);

      if (app != null) {
        await _navigateToAlarmPage(app);
        await _launchIntent();
      }
    } catch (e, stacktrace) {
      debugPrint("Erro ao tentar abrir o app: $e");
      debugPrint("Stacktrace: $stacktrace");
      timeStorage.setIsLoading(false);
    } finally {
      timeStorage.setIsLoading(false);
    }
  }

  Future<AppModel?> _returnAppfromName(String packageName) async {
    final viewModel =
        Provider.of<AppViewModel>(navigatorKey.currentContext!, listen: false);
    final AppModel? app = await viewModel.returnAppModel(packageName);
    return app;
  }

  Future<void> _navigateToAlarmPage(AppModel app) async {
    navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => AlarmPage(
                  app: app,
                )),
        (route) => true); // Before was false

    await Future.delayed(const Duration(seconds: 3));
  }

  Future<void> _launchIntent() async {
    // ignore: prefer_const_declarations
    final intent = const AndroidIntent(
      package: "com.example.detox_app",
      action: "android.intent.action.VIEW",
      componentName: "com.example.detox_app.MainActivity", // MainActivity path
      flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    await intent.launch();
  }
}
