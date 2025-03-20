// ignore_for_file: use_build_context_synchronously

import 'package:detox_app/common/widgets/floating_button.dart';
import 'package:detox_app/features/detox/screens/select_apps/widgets/app_tile.dart';
import 'package:detox_app/features/detox/screens/home/widgets/custom_circular_progress_indicator.dart';
import 'package:detox_app/features/detox/statecontrollers/select_apps_statecontroller.dart';
import 'package:detox_app/features/detox/viewmodels/app_viewmodel.dart';
import 'package:detox_app/utils/constants/colors.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
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

      context.read<SelectAppsPageStatecontroller>().initializeSelectedAppsMap(
          context
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
    final controller = context.watch<SelectAppsPageStatecontroller>();

    return Scaffold(
      floatingActionButton: FloatingButton(
        fadeAnimation: _fadeAnimation,
        buttonText: 'Save Selection',
        onPressed: () async {
          viewmodel.recieveSelectedApps(controller.selectedAppsMap);
          await Future.delayed(const Duration(seconds: 2));
          if (viewmodel.selectedAppsMap.isNotEmpty) {
            Navigator.pop(context);
          }
        },
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              TColors.primary,
              TColors.primary.withValues(alpha: 0.8),
              TColors.backgroundColor,
            ],
            stops: const [0.0, 0.2, 0.4],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: TColors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: TSizes.md),
                    Text(
                      'Select Apps',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: TColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: TSizes.defaultSpace,
                  vertical: TSizes.sm,
                ),
                padding: const EdgeInsets.all(TSizes.md),
                decoration: BoxDecoration(
                  color: TColors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                  border:
                      Border.all(color: TColors.white.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Choose Your Apps',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: TColors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems / 2),
                        Text(
                          'Installed apps: ${viewmodel.appsList.length}',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: TColors.white.withValues(alpha: 0.8),
                                  ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(TSizes.sm),
                      decoration: BoxDecoration(
                        color: TColors.white.withValues(alpha: 0.2),
                        borderRadius:
                            BorderRadius.circular(TSizes.cardRadiusMd),
                        boxShadow: [
                          BoxShadow(
                            color: TColors.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.apps_rounded,
                        size: TSizes.iconLg,
                        color: TColors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: TSizes.spaceBtwSections),
                  decoration: BoxDecoration(
                    color: TColors.backgroundColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(TSizes.cardRadiusLg),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: viewmodel.appsList.isEmpty
                      ? const Center(child: CustomCircularProgressIndicator())
                      : FadeTransition(
                          opacity: _fadeAnimation,
                          child: ListView.separated(
                            padding: const EdgeInsets.all(TSizes.defaultSpace),
                            itemCount: viewmodel.appsList.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: TSizes.spaceBtwItems),
                            itemBuilder: (context, index) {
                              final app = viewmodel.appsList[index];
                              return AppTile(app: app);
                            },
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
