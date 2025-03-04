import 'package:detox_app/data/services/background/calculate_time_service.dart';
import 'package:detox_app/features/permission/statecontroller/permission_statecontroller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  // Future<void> initializeData() async {
  //   await Future.delayed(const Duration(seconds: 2));

  //   bool recebeBool = await Permission.systemAlertWindow.request().isGranted;
  //   setState(() {
  //     verificaPermisao = recebeBool
  //         as bool?; //fiz dessa forma so para nao deixar o setState como async
  //   }); // Atualiza o estado após receber o valor da permissão
  //   debugPrint("VerificaPermissao $verificaPermisao");
  // }

  // Future<void> solicitarIgnorarOtimizacaoBateria() async {
  //   const intent = AndroidIntent(
  //     action: 'android.settings.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS',
  //     data: 'package:com.example.seu_app', // Substitua pelo ID do seu pacote
  //   );
  //   await intent.launch();
  // }

  @override
  void initState() {
    super.initState();
    //  init();
    //  Future.delayed(const Duration(seconds: 3));
    // getPermission();
    // initializeData();
    //  Future.delayed(const Duration(seconds: 3));
    fetchAppUsage(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final controller =
        Provider.of<PermissionStateController>(context, listen: true);

    return (controller.isBothPermissionsAccepted() == true
        ? const HomePage()
        : const PedirPermissaoPage());
  }
}
