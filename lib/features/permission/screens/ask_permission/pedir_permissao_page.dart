import 'package:flutter/material.dart';
import 'package:dash_bubble/dash_bubble.dart';

class PedirPermissaoPage extends StatefulWidget {
  const PedirPermissaoPage({super.key});

  @override
  State<PedirPermissaoPage> createState() => _PedirPermissaoPageState();
}

class _PedirPermissaoPageState extends State<PedirPermissaoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
              "O aplicativo só consegue funcionar aceitando a permissão de sobrepor-se sobre outros apps"),
          ElevatedButton(
              onPressed: () => requestOverlayPermission(),
              child: const Text("Aceitar permissão"))
        ],
      )),
    );
  }
}

Future<void> requestOverlayPermission() async {
  //pedir para o usuario permissao para sobrepor outros apps
  final isGranted =
      await DashBubble.instance.requestOverlayPermission(); //pede a permissao
  if (isGranted) {
    debugPrint("Permissao foi aceita");
  } else {
    debugPrint("Permissao negada");
  }
}
