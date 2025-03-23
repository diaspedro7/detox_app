import 'package:detox_app/utils/constants/colors.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:detox_app/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class StopButton extends StatelessWidget {
  const StopButton({
    super.key,
    required this.service,
  });

  final FlutterBackgroundService service;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        service.invoke('telaJaExibida', {'valor': false});
        service.on('telaJaExibida').listen((event) {
          if (event != null) {
            debugPrint(
                "TelaJaExibida dentro do exibir page: ${event['valor']}");
          }
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: TColors.error,
        side: const BorderSide(color: TColors.white),
        padding: const EdgeInsets.symmetric(vertical: TSizes.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TSizes.buttonRadius),
        ),
        elevation: 2,
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.stop_circle_outlined,
          ),
          SizedBox(width: TSizes.sm),
          Text(
            TTexts.ok,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
