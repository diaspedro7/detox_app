// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import

import 'package:detox_app/common/widgets/circular_slide_widget.dart';
import 'package:detox_app/features/detox/screens/home/widgets/add_apps.dart';
import 'package:detox_app/features/detox/screens/home/widgets/select_apps_expansion_tile.dart';
import 'package:detox_app/features/detox/statecontrollers/circular_slide_statecontroller.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(TSizes.lg),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Consumer<CircularSlideStateController>(
                //   builder: (context, controller, child) =>
                //       CircularSlide(controller: controller),
                // ),
                // SelectAppsExpansionTile(),
                Text("Dopamini"),
                SizedBox(height: 500),
                Consumer<AppViewModel>(
                  builder: (context, viewmodel, child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Monitored apps: ${viewmodel.monitoredApps.length}"),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      SizedBox(
                        height: 60,
                        child: Row(
                          children: [
                            AddAppsWidget(),
                            Expanded(
                              child: ListView.builder(
                                  itemCount: viewmodel.monitoredApps.length,
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: TSizes.twelve),
                                  itemBuilder: (context, index) {
                                    return Container(
                                      height: TSizes.addAppsWidget,
                                      width: TSizes.addAppsWidget,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            TSizes.twelve),
                                      ),
                                      child: Image.memory(
                                        viewmodel.monitoredApps[index].appIcon,
                                        width: TSizes.appsImage,
                                        height: TSizes.appsImage,
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
