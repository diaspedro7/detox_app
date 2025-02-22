import 'dart:async';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:app_usage/app_usage.dart';
import 'package:detox_app/app.dart';
import 'package:detox_app/features/detox/screens/alarm/alarm_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'data/services/time_storage_hive.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();

  await Hive.initFlutter();
  await Hive.openBox("obterTempoBackground");

  runApp(const MyApp());

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

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
      iosConfiguration: IosConfiguration(),
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: false,
      ));

  await service.startService();
  // Inicia o serviço
  bool isStarted = await service.startService();
  if (isStarted) {
    debugPrint("Serviço inicializado com sucesso");
  } else {
    debugPrint("Falha ao iniciar o serviço");
  }
  service.invoke('telaJaExibida', {'valor': false});
  debugPrint("Servico startou");
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  bool telaJaExibida = false;

  service.on('telaJaExibida').listen((event) {
    debugPrint("Entrou no servico");

    if (event != null) {
      debugPrint("Event nao eh null :)");
      telaJaExibida = event['valor'];
      debugPrint("TelaJaExibida: $telaJaExibida");
    } else {
      telaJaExibida = false;
    }
  });

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen(
      (event) {
        service.setAsForegroundService();
      },
    );

    service.on('setAsBackground').listen((event) async {
      service.setAsBackgroundService();
      debugPrint("Background rooooodando!---");
      try {
        debugPrint("Entrou no background");
        if (telaJaExibida) {
          debugPrint("Entrou direto");
          service.invoke('entrarDireto', {'isTrue': true});
        } else {
          Timer? timer;

          //await obterTempo(service);
          debugPrint("Entrou no else");
          restartTimer(service, timer);
        }

        debugPrint("O background continuou!!!");
      } catch (e) {
        debugPrint("Erro no background: $e");
      }
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });
}

void restartTimer(ServiceInstance service, Timer? timer) async {
  timer = Timer.periodic(const Duration(seconds: 5), (timer) {
    service.on('desligarTimer').listen((event) {
      debugPrint("Entrou no desligarTimer");

      timer.cancel();
    });

    obterTempo(service);
    debugPrint("Entrou no timer");
  });
}

Future<void> obterTempo(ServiceInstance service) async {
  try {
    service.invoke('obterTempoPrimeiroPlano', {'isTrue': true});
  } catch (e) {
    debugPrint("Erro ao invocar o obterTempo: $e");
  }
}

Future<void> calculaTempo(
    String result, FlutterBackgroundService service) async {
  List<String> monitoredApps = [
    'com.roblox.client',
    'com.zhiliaoapp.musically',
    'com.google.android.youtube'
  ];

  if (monitoredApps.contains(result)) {
    int tempo = getTempoSalvo();
    tempo = tempo + 5;
    debugPrint("TempoSalvo: $tempo");
    setTempoSalvo(tempo);
    debugPrint("Tempo de intervalo: ${getTempoDeIntervaloSomado()}");
    if (tempo >= getTempoDeIntervaloSomado()) {
      debugPrint("Entrou no passar o intervalo");
      setTempoDeIntervaloSomado(tempo + getTempoTemporizador());
      exibirTela(service);
    }
  }
}

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

Future<List<AppUsageInfo>> fetchAppUsage(DateTime dataInicial) async {
  final List<String> monitoredApps = ['Roblox', 'TikTok', 'Youtube'];

  try {
    DateTime endDate = DateTime.now();
    DateTime startDate = endDate.subtract(const Duration(days: 30));

    debugPrint("endDate $endDate");
    debugPrint("StartDate $startDate");

    await Future.delayed(const Duration(seconds: 2));

    List<AppUsageInfo> infoList =
        await AppUsage().getAppUsage(startDate, endDate);

    List<AppUsageInfo> filteredUsage = infoList
        .where((info) => monitoredApps.any((app) =>
            info.appName.toLowerCase().contains(app.toLowerCase()) ||
            info.packageName.toLowerCase().contains(app.toLowerCase())))
        .toList();

    return filteredUsage;
  } on Exception catch (exception) {
    debugPrint("AppUsageException: $exception");
    return List.empty();
  }
}
