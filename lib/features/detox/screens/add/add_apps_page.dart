// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:detox_app/common/widgets/circular_slide_widget.dart';
import 'package:detox_app/data/services/selected_apps_hive.dart';
import 'package:detox_app/features/detox/screens/home/widgets/select_apps_expansion_tile.dart';
import 'package:detox_app/features/detox/statecontrollers/circular_slide_statecontroller.dart';
import 'package:detox_app/features/detox/viewmodels/app_viewmodel.dart';
import 'package:detox_app/utils/constants/colors.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddAppsPage extends StatelessWidget {
  const AddAppsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewmodel = context.watch<AppViewModel>();
    return Scaffold(
        backgroundColor: TColors.backgroundColor,
        appBar: AppBar(
          title: const Text(
            "Add apps",
            style: TextStyle(color: TColors.white),
          ),
          centerTitle: true,
          actions: [
            Consumer<CircularSlideStateController>(
              builder: (context, controller, child) => IconButton(
                icon: Icon(
                  Icons.save_rounded,
                  color: TColors.white,
                ),
                onPressed: () async {
                  viewmodel.setSelectedAppsLocalDatabase();
                  viewmodel.addMonitoredApps();
                  viewmodel.setMapMonitoredAppsTime(
                      viewmodel.getMonitoredAppsLocalDatabase(),
                      controller.radialValue.ceil() * 60);
                  debugPrint("MapAppTime: ${getAppTimeMap()}");
                  debugPrint("Salvado com sucesso");
                  await Future.delayed(Duration(seconds: 3));
                  Navigator.pop(context);
                },
              ),
            )
          ],
          backgroundColor: TColors.primary,
        ),
        body: Padding(
            padding: EdgeInsets.all(TSizes.lg),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SelectAppsExpansionTile(),
                  Consumer<CircularSlideStateController>(
                    builder: (context, controller, child) =>
                        CircularSlide(controller: controller),
                  ),
                ],
              ),
            )));
  }
}
