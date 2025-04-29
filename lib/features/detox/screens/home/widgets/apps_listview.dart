import 'package:detox_app/features/detox/screens/home/widgets/add_apps_button.dart';
import 'package:detox_app/features/detox/screens/home/widgets/app_home_tile.dart';
import 'package:detox_app/features/detox/screens/home/widgets/custom_circular_progress_indicator.dart';
import 'package:detox_app/features/detox/viewmodels/app_viewmodel.dart';
import 'package:detox_app/utils/constants/colors.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:detox_app/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppsListView extends StatelessWidget {
  const AppsListView({super.key});

  @override
  Widget build(BuildContext context) {
    // final viewModel = Provider.of<AppViewModel>(context, listen: true);
    // final selectedApps = context.read<SelectedAppsStorageRepository>();
    final viewModel = context.read<AppViewModel>();

    return Flexible(
      child: FutureBuilder<bool>(
          future: viewModel.loadMonitoredApps(context),
          builder: (context, snapshot) {
            debugPrint("Entrou no FutureBuilder");
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
              builder: (context, viewmodel, child) => ListView.builder(
                padding: const EdgeInsets.only(
                    top: TSizes.md, left: TSizes.sm, right: TSizes.sm),
                itemCount: viewmodel.monitoredApps.length + 1,
                itemBuilder: (context, index) {
                  debugPrint(
                      "Tamanho da lista: ${viewmodel.monitoredApps.length}");
                  if (index == 0) {
                    return const AddAppsWidget();
                  }

                  return Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Material(
                        color: TColors.neoBackground,
                        borderRadius: BorderRadius.circular(TSizes.twelve),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(TSizes.twelve),
                          onTap: () async {
                            // await Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => AppDetailsPage(
                            //               app: viewmodel
                            //                   .monitoredApps[index - 1],
                            //             )));
                          },
                          child: AppHomeTile(
                              app: viewmodel.monitoredApps[index - 1]),
                        ),
                      ));
                },
              ),
            );
          }),
    );
  }
}
