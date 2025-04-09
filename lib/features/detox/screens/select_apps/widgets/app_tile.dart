import 'package:detox_app/features/detox/models/app_model.dart';
import 'package:detox_app/features/detox/viewmodels/select_apps_viewmodel.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppTile extends StatelessWidget {
  const AppTile({
    super.key,
    required this.app,
  });

  final AppModel app;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SelectAppsPageViewModel>();
    // final viewmodel = context.watch<AppViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: TSizes.sm, horizontal: TSizes.md),
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: TSizes.twelve, horizontal: TSizes.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(TSizes.twelve),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: TSizes.sm,
              offset: const Offset(0, TSizes.appsImage / 2),
            ),
          ],
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
              value: controller.selectedAppsMap[app.appPackageName] ?? false,
              // value: viewmodel.selectedAppsMap[app.appPackageName] ?? false,
              onChanged: (value) {
                controller.toggleAppSelection(app.appPackageName);
                // viewmodel.selectApp(app.appPackageName);
              },
            )
          ],
        ),
      ),
    );
  }
}
