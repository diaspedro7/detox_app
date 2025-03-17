import 'package:detox_app/features/detox/screens/home/widgets/add_apps_button.dart';
import 'package:detox_app/features/detox/screens/home/widgets/custom_circular_progress_indicator.dart';
import 'package:detox_app/features/detox/viewmodels/app_viewmodel.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppsGridView extends StatelessWidget {
  const AppsGridView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Consumer<AppViewModel>(
        builder: (context, viewmodel, child) => viewmodel.monitoredApps.isEmpty
            ? const CustomCircularProgressIndicator()
            : GridView.builder(
                padding: const EdgeInsets.only(
                    top: TSizes.md, left: TSizes.sm, right: TSizes.sm),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    // MediaQuery.of(context).size.width > 600 ? 6 : 4,
                    crossAxisSpacing: TSizes.gridViewSpacing,
                    mainAxisSpacing: TSizes.gridViewSpacing,
                    childAspectRatio: 1.0,
                    mainAxisExtent: 55),
                itemCount: viewmodel.monitoredApps.length + 1,
                itemBuilder: (context, index) {
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 200 + (index * 100)),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return index == 0
                          ? const AddAppsWidget()
                          : Image.memory(
                              viewmodel.monitoredApps[index - 1].appIcon,
                              fit: BoxFit.cover,
                            );
                    },
                  );
                },
              ),
      ),
    );
  }
}
