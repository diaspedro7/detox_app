import 'package:detox_app/common/widgets/circular_slide_widget.dart';
import 'package:detox_app/data/repositories/selected_apps_storage_repository.dart';
import 'package:detox_app/features/detox/screens/home/widgets/select_apps.dart';
import 'package:detox_app/features/detox/viewmodels/circular_slide_viewmodel.dart';
import 'package:detox_app/features/detox/viewmodels/select_apps_viewmodel.dart';
import 'package:detox_app/features/detox/viewmodels/app_viewmodel.dart';
import 'package:detox_app/utils/constants/colors.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:detox_app/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showAddAppsModal(BuildContext context) {
  final selectedApps = context.read<SelectedAppsStorageRepository>();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    constraints: const BoxConstraints(maxHeight: TSizes.showModalMaxHeight),
    // backgroundColor: TColors.dark,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(TSizes.xl)),
    ),
    builder: (context) => Padding(
      padding: const EdgeInsets.all(TSizes.md),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  TTexts.addApplication,
                  style: Theme.of(context).textTheme.headlineLarge,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            const SizedBox(height: TSizes.xs),

            Text(TTexts.chooseAppToMonitor,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .apply(color: TColors.darkGrey)),

            const SizedBox(height: TSizes.spaceBtwSections),
            //const SelectAppsExpansionTile(),
            Consumer<AppViewModel>(
              builder: (context, viewmodel, child) => Consumer<
                      SelectAppsPageViewModel>(
                  builder: (context, pageController, child) => Material(
                      color: TColors.neoBackground,
                      borderRadius: BorderRadius.circular(TSizes.twelve),
                      child: InkWell(
                          borderRadius: BorderRadius.circular(TSizes.twelve),
                          onTap: () async {
                            Navigator.pushNamed(context, "/select");
                          },
                          child: const SelectApps()))),
            ),
            Consumer<CircularSlideViewModel>(
              builder: (context, controller, child) =>
                  CircularSlide(controller: controller),
            ),
            Consumer<SelectAppsPageViewModel>(
              builder: (context, selectPageController, child) =>
                  Consumer<AppViewModel>(
                builder: (context, viewmodel, child) =>
                    Consumer<CircularSlideViewModel>(
                  builder: (context, controller, child) => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.primary,
                      foregroundColor: TColors.white,
                      minimumSize: const Size(
                          double.infinity, TSizes.elevatedButtonHeight),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(TSizes.twelve),
                      ),
                    ),
                    onPressed: () async {
                      viewmodel.setSelectedAppsLocalDatabase(); //V
                      await viewmodel.setMonitoredAppsLocalDatabase(); //V
                      viewmodel.setMapAppsTime(
                          await viewmodel.getMonitoredAppsLocalDatabase(),
                          controller.radialValue.ceil() * TSizes.oneMin);
                      selectPageController.mapClear();
                      viewmodel.clearAppsList();
                      debugPrint("MapAppTime: ${selectedApps.getAppTimeMap()}");
                      debugPrint("Salvado com sucesso");
                      await Future.delayed(const Duration(seconds: 3));
                    },
                    child: Text(
                      TTexts.saveChanges,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .apply(color: TColors.white),
                      // style:
                      //     TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: TSizes.md),
          ],
        ),
      ),
    ),
  );
}
