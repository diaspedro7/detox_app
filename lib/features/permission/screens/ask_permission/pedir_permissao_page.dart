// ignore_for_file: await_only_futures

import 'package:detox_app/features/permission/statecontroller/permission_statecontroller.dart';
import 'package:detox_app/utils/constants/colors.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class PedirPermissaoPage extends StatelessWidget {
  const PedirPermissaoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextStyle? title = Theme.of(context).textTheme.titleLarge;
    final TextStyle? subtitle = Theme.of(context).textTheme.titleMedium;
    final TextStyle textInsideButton =
        Theme.of(context).textTheme.labelLarge!.apply(color: TColors.white);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(TSizes.xl),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //TODO: Transform these texts into constants
            Text(
              "O aplicativo só consegue funcionar aceitando as seguintes permissões:",
              style: title,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TSizes.spaceBtwTitles),
            Column(
              children: [
                Text(
                  "1. Permissão para sobrepor outros apps.",
                  style: subtitle,
                ),
                const SizedBox(height: TSizes.sm),
                Consumer<PermissionStateController>(
                  builder: (context, controller, child) => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () async {
                          bool isGranted = await requestOverlayPermission();
                          controller.setOverlayPermission(isGranted);
                        },
                        style: Theme.of(context)
                            .elevatedButtonTheme
                            .style!
                            .copyWith(
                                backgroundColor:
                                    controller.overlayPermission == true
                                        ? const WidgetStatePropertyAll(
                                            TColors.primary)
                                        : const WidgetStatePropertyAll(
                                            TColors.error)),
                        child: Text(
                          "Aceitar",
                          style: textInsideButton,
                        )),
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            Column(
              children: [
                Text("2. Permissão para desativar a otimização de bateria.",
                    style: subtitle),
                const SizedBox(height: TSizes.sm),
                Consumer<PermissionStateController>(
                  builder: (context, controller, child) => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () async {
                          bool isGranted = await init();
                          controller.setBatteryPermission(isGranted);
                        },
                        style: Theme.of(context).elevatedButtonTheme.style,
                        child: Text(
                          "Aceitar",
                          style: textInsideButton,
                        )),
                  ),
                ),
              ],
            ),
          ],
        )),
      ),
    );
  }
}

Future<bool> requestOverlayPermission() async {
  //pedir para o usuario permissao para sobrepor outros apps
  try {
    final isGranted = await Permission.systemAlertWindow
        .request()
        .isGranted; //pede a permissao
    if (isGranted) {
      debugPrint("Permissao foi aceita");
    } else {
      debugPrint("Permissao negada");
    }
    return isGranted;
  } catch (e) {
    debugPrint("Erro ao pedir permissao: $e");
    return false;
  }
}

Future<bool> init() async {
  try {
    var status = await Permission.ignoreBatteryOptimizations.status;
    debugPrint("status: $status");

    if (!status.isGranted) {
      final result = await Permission.ignoreBatteryOptimizations.request();
      return result.isGranted;
    }

    return true;
  } catch (e) {
    debugPrint("Error requesting battery optimization: $e");
    return false;
  }
}
