import 'package:detox_app/features/detox/screens/home/widgets/app_tile.dart';
import 'package:detox_app/features/detox/screens/home/widgets/custom_circular_progress_indicator.dart';
import 'package:detox_app/features/detox/viewmodels/app_viewmodel.dart';
import 'package:detox_app/utils/constants/colors.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectAppsExpansionTile extends StatelessWidget {
  const SelectAppsExpansionTile({super.key});

  @override
  Widget build(BuildContext context) {
    final viewmodel =
        context.watch<AppViewModel>(); // Obtém o ViewModel do Provider

    return Card(
      elevation: TSizes.sm,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TSizes.md),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent, // Remove a linha padrão
            splashColor: Colors.transparent, // Remove splash quadrado
            highlightColor: Colors.transparent),
        child: ExpansionTile(
          collapsedBackgroundColor: TColors.white,
          backgroundColor: TColors.white,
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TSizes.md),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TSizes.md),
          ),
          title: Text("Select Apps",
              style: Theme.of(context).textTheme.titleMedium),
          onExpansionChanged: (value) {
            viewmodel.getAppsList();
            if (!value) {
              viewmodel.setSelectedAppsLocalDatabase();
              viewmodel.addMonitoredApps();
            }
          },
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: TColors.backgroundColor,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(TSizes.md)),
              ),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Installed apps: ${viewmodel.appsList.length}"),
                  ],
                ),
                viewmodel.appsList.isEmpty
                    ? const CustomCircularProgressIndicator()
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: viewmodel.appsList.length,
                        itemBuilder: (context, index) {
                          final app = viewmodel.appsList[index];
                          return AppTile(app: app, viewmodel: viewmodel);
                        },
                      ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
