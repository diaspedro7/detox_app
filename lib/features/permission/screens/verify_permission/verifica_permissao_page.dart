import 'package:android_intent_plus/android_intent.dart';
import 'package:android_power_manager/android_power_manager.dart';
import 'package:dash_bubble/dash_bubble.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../data/services/background/calculate_time_service.dart';
import '../../../detox/screens/home/home_page.dart';
import '../ask_permission/pedir_permissao_page.dart';

class VerificaPermissaoPage extends StatefulWidget {
  const VerificaPermissaoPage({super.key});

  @override
  State<VerificaPermissaoPage> createState() => _VerificaPermissaoPageState();
}

class _VerificaPermissaoPageState extends State<VerificaPermissaoPage> {
  bool? verificaPermisao;
  bool? verificaPermisaoObterDados;

  Future<void> initializeData() async {
    await Future.delayed(const Duration(seconds: 2));

    bool recebeBool = await DashBubble.instance.requestOverlayPermission();
    setState(() {
      verificaPermisao =
          recebeBool; //fiz dessa forma so para nao deixar o setState como async
    }); // Atualiza o estado após receber o valor da permissão
    debugPrint("VerificaPermissao $verificaPermisao");
  }

  Future<void> solicitarIgnorarOtimizacaoBateria() async {
    const intent = AndroidIntent(
      action: 'android.settings.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS',
      data: 'package:com.example.seu_app', // Substitua pelo ID do seu pacote
    );
    await intent.launch();
  }

  void init() async {
    var status = await Permission.ignoreBatteryOptimizations.status;
    debugPrint("status: $status");
    if (status.isGranted) {
      debugPrint(
          "isIgnoring: ${(await AndroidPowerManager.isIgnoringBatteryOptimizations)}");
      final isIgnoring =
          await AndroidPowerManager.isIgnoringBatteryOptimizations;

      if (isIgnoring != null && !isIgnoring) {
        AndroidPowerManager.requestIgnoreBatteryOptimizations();
      }
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.ignoreBatteryOptimizations,
      ].request();
      debugPrint(
          "permission value: ${statuses[Permission.ignoreBatteryOptimizations]}");
      if (statuses[Permission.ignoreBatteryOptimizations]!.isGranted) {
        AndroidPowerManager.requestIgnoreBatteryOptimizations();
      } else {
        return;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    init();
    Future.delayed(const Duration(seconds: 3));
    initializeData();
    Future.delayed(const Duration(seconds: 3));
    fetchAppUsage(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    if (verificaPermisao == null) {
      // Mostra uma tela de carregamento enquanto a permissão é verificada
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return (verificaPermisao == true
        ? const HomePage()
        : const PedirPermissaoPage());
  }
}
