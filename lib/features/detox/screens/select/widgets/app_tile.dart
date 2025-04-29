import 'package:detox_app/features/detox/models/app_model.dart';
import 'package:detox_app/features/detox/viewmodels/select_apps_viewmodel.dart';
import 'package:detox_app/utils/constants/colors.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppTileCheckBox extends StatelessWidget {
  const AppTileCheckBox({
    super.key,
    required this.app,
  });

  final AppModel app;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SelectAppsPageViewModel>();
    // final viewmodel = context.watch<AppViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.sm),
      child: Material(
        color: TColors.neoBackground,
        borderRadius: BorderRadius.circular(TSizes.twelve),
        child: InkWell(
          borderRadius: BorderRadius.circular(TSizes.twelve),
          onTap: () {
            controller.toggleAppSelection(app.appPackageName);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
                vertical: TSizes.twelve, horizontal: TSizes.md),
            decoration: BoxDecoration(
              // color: TColors.neoBackground,
              borderRadius: BorderRadius.circular(TSizes.twelve),
            ),
            child: Row(
              children: [
                app.appIcon.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(TSizes.sm),
                        child: Image.memory(
                          app.appIcon,
                          width: TSizes.appsImage,
                          height: TSizes.appsImage,
                        ),
                      )
                    : const Icon(Icons.android,
                        size: TSizes.appsImage, color: Colors.grey),
                const SizedBox(width: TSizes.twelve),
                Expanded(
                  child: Text(
                    app.appName,
                    style: Theme.of(context).textTheme.titleSmall,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Checkbox(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(TSizes.xs),
                  ),
                  activeColor: Colors.blueAccent,
                  value:
                      controller.selectedAppsMap[app.appPackageName] ?? false,
                  // value: viewmodel.selectedAppsMap[app.appPackageName] ?? false,
                  onChanged: (value) {
                    controller.toggleAppSelection(app.appPackageName);
                    // viewmodel.selectApp(app.appPackageName);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
