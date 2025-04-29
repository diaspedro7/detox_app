// ignore_for_file: await_only_futures

import 'package:detox_app/data/services/background/calculate_time_service.dart';
import 'package:detox_app/features/permission/screens/ask_permission/widgets/permission_button.dart';
import 'package:detox_app/features/permission/viewmodel/permission_viewmodel.dart';
import 'package:detox_app/utils/constants/colors.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:detox_app/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class PedirPermissaoPage extends StatelessWidget {
  const PedirPermissaoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextStyle? title = Theme.of(context).textTheme.titleLarge;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(TSizes.xl),
        child: Center(
            child: Consumer<PermissionViewModel>(
          builder: (context, controller, child) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //TODO: Transform these texts into constants
              Container(
                padding: const EdgeInsets.all(TSizes.lg),
                decoration: BoxDecoration(
                    color: TColors.neoBackground,
                    borderRadius: BorderRadius.circular(TSizes.twelve)),
                child: Text(
                  TTexts.permissionTitle,
                  style: title,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwTitles),

              PermissionButton(
                  onPressed: () async {
                    debugPrint("Entrou");
                    bool isGranted = await requestOverlayPermission();
                    controller.setOverlayPermission(isGranted);
                  },
                  permissionText: TTexts.permissionOverApps),

              const SizedBox(height: TSizes.spaceBtwSections),
              PermissionButton(
                  onPressed: () => fetchAppUsage(),
                  permissionText: TTexts.permissionUsage),

              const SizedBox(height: TSizes.spaceBtwSections),
              PermissionButton(
                  onPressed: () async {
                    bool isGranted = await init();
                    controller.setBatteryPermission(isGranted);
                  },
                  permissionText: TTexts.permissionBattery),
            ],
          ),
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
