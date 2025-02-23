import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:detox_app/features/detox/screens/alarm/alarm_page.dart';
import 'package:detox_app/main.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

Future<void> exibirTela(FlutterBackgroundService service) async {
  service.invoke('telaJaExibida', {'valor': true});

  navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const AlarmPage()),
      (route) => false); // Isso impede o usuário de voltar para a tela anterior

  await Future.delayed(const Duration(seconds: 3));
  try {
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
    service.on('telaJaExibida').listen((event) {
      if (event != null) {
        debugPrint("TelaJaExibida no intent launch: ${event['valor']}");
      }
    });
  } catch (e, stacktrace) {
    debugPrint("Erro ao tentar abrir o app: $e");
    debugPrint("Stacktrace: $stacktrace");
  }
}
