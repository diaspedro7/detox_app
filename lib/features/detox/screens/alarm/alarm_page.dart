import 'package:detox_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class AlarmPage extends StatelessWidget {
  const AlarmPage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = FlutterBackgroundService();

    return Scaffold(
      backgroundColor: TColors.error,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                service.invoke('telaJaExibida', {'valor': false});
                service.on('telaJaExibida').listen((event) {
                  if (event != null) {
                    debugPrint(
                        "TelaJaExibida dentro do exibir page: ${event['valor']}");
                  }
                });
              },
              child: Container(
                height: 50,
                width: 100,
                color: Colors.blue,
                child: const Center(
                  child: Text(
                    "Stop",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
