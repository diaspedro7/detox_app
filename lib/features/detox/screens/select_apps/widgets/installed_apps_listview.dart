import 'package:detox_app/features/detox/screens/select_apps/widgets/app_tile.dart';
import 'package:detox_app/features/detox/viewmodels/app_viewmodel.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InstalledAppsListView extends StatelessWidget {
  const InstalledAppsListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final viewmodel = context.watch<AppViewModel>();

    return ListView.separated(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      itemCount: viewmodel.appsList.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: TSizes.spaceBtwItems),
      itemBuilder: (context, index) {
        final app = viewmodel.appsList[index];
        return AppTile(app: app);
      },
    );
  }
}
