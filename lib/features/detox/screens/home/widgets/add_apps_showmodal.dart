import 'package:detox_app/common/widgets/circular_slide_widget.dart';
import 'package:detox_app/data/services/selected_apps_hive.dart';
import 'package:detox_app/features/detox/screens/home/widgets/select_apps_expansion_tile.dart';
import 'package:detox_app/features/detox/statecontrollers/circular_slide_statecontroller.dart';
import 'package:detox_app/features/detox/viewmodels/app_viewmodel.dart';
import 'package:detox_app/utils/constants/colors.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showAddAppsModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    //scrollControlDisabledMaxHeightRatio: 300,
    constraints: const BoxConstraints(maxHeight: 700),
    backgroundColor: TColors.backgroundColor,
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
                  "Add application",
                  style: Theme.of(context).textTheme.headlineLarge,
                  textAlign: TextAlign.start,
                ),
              ],
            ),

            const SizedBox(height: TSizes.spaceBtwSections),
            const SelectAppsExpansionTile(),
            // const SizedBox(height: 16),
            Consumer<CircularSlideStateController>(
              builder: (context, controller, child) =>
                  CircularSlide(controller: controller),
            ),
            Consumer<AppViewModel>(
              builder: (context, viewmodel, child) =>
                  Consumer<CircularSlideStateController>(
                builder: (context, controller, child) => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primary,
                    foregroundColor: TColors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    viewmodel.setSelectedAppsLocalDatabase();
                    viewmodel.addMonitoredApps();
                    viewmodel.setMapMonitoredAppsTime(
                        viewmodel.getMonitoredAppsLocalDatabase(),
                        controller.radialValue.ceil() * 60);
                    debugPrint("MapAppTime: ${getAppTimeMap()}");
                    debugPrint("Salvado com sucesso");
                    await Future.delayed(const Duration(seconds: 3));
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Save Changes",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    ),
  );
}
