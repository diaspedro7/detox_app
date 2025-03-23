import 'package:detox_app/data/services/selected_apps_hive.dart';
import 'package:detox_app/features/detox/screens/details/app_details_page.dart';
import 'package:detox_app/features/detox/screens/home/widgets/add_apps_button.dart';
import 'package:detox_app/features/detox/screens/home/widgets/custom_circular_progress_indicator.dart';
import 'package:detox_app/features/detox/viewmodels/app_viewmodel.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:detox_app/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppsGridView extends StatelessWidget {
  const AppsGridView({
    super.key,
  });

  Future<bool> _loadMonitoredApps(BuildContext context) async {
    try {
      await Future.delayed(const Duration(seconds: 2)); // Delay intencional
      final apps = await getMonitoredApps();
      if (!context.mounted) return false;

      final viewModel = Provider.of<AppViewModel>(context, listen: false);
      await viewModel.getSpecificApps(apps);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: FutureBuilder<bool>(
          future: _loadMonitoredApps(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CustomCircularProgressIndicator(),
              );
            }

            if (snapshot.hasError || snapshot.data == false) {
              return const Center(
                child: Text(TTexts.errorLoadingApps),
              );
            }

            return Consumer<AppViewModel>(
              builder: (context, viewmodel, child) => GridView.builder(
                padding: const EdgeInsets.only(
                    top: TSizes.md, left: TSizes.sm, right: TSizes.sm),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    // MediaQuery.of(context).size.width > 600 ? 6 : 4,
                    crossAxisSpacing: TSizes.gridViewSpacing,
                    mainAxisSpacing: TSizes.gridViewSpacing,
                    childAspectRatio: 1.0,
                    mainAxisExtent: TSizes.gridViewAppSize),
                itemCount: viewmodel.monitoredApps.length + 1,
                itemBuilder: (context, index) {
                  debugPrint(
                      "Tamanho da lista: ${viewmodel.monitoredApps.length}");
                  if (index == 0) {
                    return const AddAppsWidget();
                  }

                  return GestureDetector(
                    onTap: () async {
                      final needsUpdate = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AppDetailsPage(
                                    app: viewmodel.monitoredApps[index - 1],
                                  )));

                      if (needsUpdate == true && context.mounted) {
                        final viewModel =
                            Provider.of<AppViewModel>(context, listen: false);
                        await viewModel
                            .getSpecificApps(await getMonitoredApps());
                      }
                    },
                    child: Image.memory(
                      viewmodel.monitoredApps[index - 1].appIcon,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            );
          }),
    );
  }
}
