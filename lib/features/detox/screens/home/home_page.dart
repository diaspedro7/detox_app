// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:detox_app/features/detox/screens/home/widgets/select_apps_expansion_tile.dart';
import 'package:detox_app/features/detox/viewmodels/app_viewmodel.dart';
import 'package:detox_app/utils/constants/colors.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

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

  var radialValue = 10.0;

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
                SfRadialGauge(
                  backgroundColor: Colors.blueAccent,
                  axes: [
                    RadialAxis(
                      minimum: 0.0,
                      maximum: 60.0,
                      startAngle: 0.0,
                      endAngle: 360.0,
                      showLabels: true,
                      labelsPosition: ElementsPosition.inside,
                      showTicks: true,
                      radiusFactor: 0.5,
                    ),
                  ],
                ),
                Consumer<AppViewModel>(
                  builder: (context, viewmodel, child) =>
                      SelectAppsExpansionTile(viewmodel: viewmodel),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
