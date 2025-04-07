import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:detox_app/data/services/time_storage_hive.dart';
import 'package:detox_app/features/detox/models/app_model.dart';
import 'package:detox_app/features/detox/screens/alarm/alarm_page.dart';
import 'package:detox_app/features/detox/viewmodels/app_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:detox_app/main.dart';
import 'package:provider/provider.dart';

Future<void> exibirTela(
    //FlutterBackgroundService service,
    String packageName) async {
  // service.invoke('telaJaExibida', {'valor': true});
  if (getIsLoading()) return;

  try {
    setIsLoading(true);
    AppModel? app = await returnAppfromName(packageName);

    if (app != null) {
      navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => AlarmPage(
                    app: app,
                  )),
          (route) =>
              false); // Isso impede o usuário de voltar para a tela anterior

      await Future.delayed(const Duration(seconds: 3));
      // ignore: prefer_const_declarations
      final intent = const AndroidIntent(
        package: "com.example.detox_app",
        action: "android.intent.action.VIEW",
        componentName:
            "com.example.detox_app.MainActivity", // Substitua pelo caminho completo da sua MainActivity
        flags: [
          Flag.FLAG_ACTIVITY_NEW_TASK
        ], // Uso correto do FLAG_ACTIVITY_NEW_TASK
      );
      await intent.launch();
      // service.on('telaJaExibida').listen((event) {
      //   if (event != null) {
      //     debugPrint("TelaJaExibida no intent launch: ${event['valor']}");
      //   }
      // });
    }
  } catch (e, stacktrace) {
    debugPrint("Erro ao tentar abrir o app: $e");
    debugPrint("Stacktrace: $stacktrace");
    setIsLoading(false);
  } finally {
    setIsLoading(false);
  }
}

Future<AppModel?> returnAppfromName(String packageName) async {
  final viewModel =
      Provider.of<AppViewModel>(navigatorKey.currentContext!, listen: false);
  final AppModel? app = await viewModel.returnAppModel(packageName);
  return app;
}
