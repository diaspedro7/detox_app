// ignore_for_file: use_build_context_synchronously

import 'package:detox_app/common/widgets/custom_icon_button.dart';
import 'package:detox_app/common/widgets/floating_button.dart';
import 'package:detox_app/features/detox/screens/home/widgets/custom_circular_progress_indicator.dart';
import 'package:detox_app/common/widgets/body_background_container.dart';
import 'package:detox_app/features/detox/screens/select/widgets/display_widgets.dart';
import 'package:detox_app/features/detox/screens/select/widgets/installed_apps_listview.dart';
import 'package:detox_app/features/detox/viewmodels/select_apps_viewmodel.dart';
import 'package:detox_app/features/detox/viewmodels/app_viewmodel.dart';
import 'package:detox_app/utils/constants/colors.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:detox_app/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class SelectAppsPage extends StatefulWidget {
  const SelectAppsPage({super.key});

  @override
  State<SelectAppsPage> createState() => _SelectAppsPageState();
}

class _SelectAppsPageState extends State<SelectAppsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
    Future.microtask(() async {
      context.read<AppViewModel>().clearAppsList();

      await context.read<AppViewModel>().getAppsList();

      if (!mounted) return;

      context.read<SelectAppsPageViewModel>().initializeSelectedAppsMap(context
          .read<AppViewModel>()
          .appsList
          .map((app) => app.appPackageName)
          .toList());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewmodel = context.watch<AppViewModel>();
    //viewmodel.getAppsList();
    final controller = context.watch<SelectAppsPageViewModel>();

    return Scaffold(
      floatingActionButton: FloatingButton(
        fadeAnimation: _fadeAnimation,
        buttonText: TTexts.saveSelection,
        onPressed: () async {
          try {
            viewmodel.updateSelectedApps(controller.selectedAppsMap);
            await Future.delayed(const Duration(seconds: 2));
            if (viewmodel.selectedAppsMap.isNotEmpty) {
              Navigator.pop(context);
            }
          } catch (e) {
            debugPrint("Error in saveSelection: $e");
          }
        },
      ),
      body: Container(
        color: TColors.neoBackground,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: Row(
                  children: [
                    CustomIconButton(
                        // iconSize: TSizes.buttonHeight,
                        icon: PhosphorIcons.caretLeft(),
                        onPressed: () => Navigator.pop(context)),
                    const SizedBox(width: TSizes.md),
                    Text(
                      TTexts.selectApps,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: TColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                    ),
                  ],
                ),
              ),
              TitleDisplay(
                quantityWidget: Text(
                  '${TTexts.installedApps} ${viewmodel.appsList.length}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: TColors.white.withValues(alpha: 0.8),
                      ),
                ),
              ),
              Expanded(
                child: BodyBackgroundContainer(
                  child: viewmodel.appsList.isEmpty
                      ? const Center(child: CustomCircularProgressIndicator())
                      : const InstalledAppsListView(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
