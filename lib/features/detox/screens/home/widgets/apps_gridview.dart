import 'package:detox_app/data/repositories/selected_apps_storage_repository.dart';
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

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AppViewModel>(context, listen: false);
    final selectedApps = context.read<SelectedAppsStorageRepository>();

    return Flexible(
      child: FutureBuilder<bool>(
          future: viewModel.loadMonitoredApps(context),
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
                        await viewModel.getSpecificApps(
                            await selectedApps.getMonitoredApps());
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
