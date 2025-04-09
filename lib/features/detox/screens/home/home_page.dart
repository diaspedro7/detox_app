// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import

import 'package:detox_app/common/widgets/circular_slide_widget.dart';
import 'package:detox_app/data/services/selected_apps_hive.dart';
import 'package:detox_app/data/services/time_storage_hive.dart';
import 'package:detox_app/features/detox/screens/home/widgets/add_apps_button.dart';
import 'package:detox_app/features/detox/screens/home/widgets/apps_count_display.dart';
import 'package:detox_app/features/detox/screens/home/widgets/apps_gridview.dart';
import 'package:detox_app/features/detox/screens/home/widgets/home_title.dart';
import 'package:detox_app/features/detox/screens/home/widgets/switch.dart';
import 'package:detox_app/features/detox/screens/home/widgets/switch_text.dart';
import 'package:detox_app/features/detox/viewmodels/circular_slide_viewmodel.dart';
import 'package:detox_app/features/detox/viewmodels/home_page_viewmodel.dart';
import 'package:detox_app/features/detox/viewmodels/app_viewmodel.dart';
import 'package:detox_app/utils/constants/colors.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/services/permission_storage_hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    if (getPermission() == false) {
      setPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HomeTitle(),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Switch part
              Column(
                children: [
                  //Display text
                  SwitchText(),
                  SizedBox(height: TSizes.md),

                  /// Switch Widget
                  customSwitch(context),
                ],
              ),

              const SizedBox(height: TSizes.spaceBtwSections),

              /// Apps Counter
              SizedBox(
                height: TSizes.appsCounterDisplayHeight,
                child: Column(
                  children: [
                    Consumer<AppViewModel>(
                      builder: (context, viewmodel, child) =>
                          AppsCounterDisplay(
                        quantity: viewmodel.monitoredApps.length,
                      ),
                    ),

                    /// GridView apps
                    AppsGridView(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
