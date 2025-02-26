// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:detox_app/data/services/time_storage_hive.dart';
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
                  axes: [
                    RadialAxis(
                      minimum: 0.0,
                      maximum: 60.0,
                      startAngle: 0.0,
                      endAngle: 360.0,
                      showLabels: false,
                      labelsPosition: ElementsPosition.inside,
                      showTicks: false,
                      radiusFactor: 0.8,
                      axisLineStyle: const AxisLineStyle(
                        cornerStyle: CornerStyle.bothCurve,
                      ),
                      pointers: [
                        RangePointer(
                          value: radialValue,
                          cornerStyle: CornerStyle.bothCurve,
                          width: 12,
                          sizeUnit: GaugeSizeUnit.logicalPixel,
                          color: TColors.primary,
                        ),
                        MarkerPointer(
                          value: radialValue,
                          enableDragging: true,
                          onValueChanged: (value) {
                            setState(() {
                              debugPrint("Value: ${value.ceil()}");
                              //if try to pass from 60 to 0 it denies
                              if ((radialValue.ceil() <= 60 &&
                                      radialValue.ceil() >= 50) &&
                                  (value.ceil() >= 0 && value.ceil() <= 20)) {
                                debugPrint("Denies1");
                                radialValue = 60.0;
                              }
                              //if try to pass from 0 to 60 it also denies
                              else if ((radialValue.ceil() >= 0 &&
                                      radialValue.ceil() <= 10) &&
                                  (value.ceil() <= 61 && value.ceil() >= 40)) {
                                debugPrint("Denies2");

                                radialValue = 0.0;
                              } else {
                                radialValue = value;
                              }
                              //TODO: Change the setState to provider
                              setIntervalTime(radialValue.ceil());
                            });
                          },
                          markerHeight: 40.0,
                          markerWidth: 40.0,
                          markerType: MarkerType.circle,
                          color: TColors.white,
                          // borderWidth: 1.0,
                          // borderColor: TColors.grey,
                        ),
                      ],
                      annotations: [
                        GaugeAnnotation(
                            angle: 90,
                            axisValue: 5.0,
                            positionFactor: 0.1,
                            widget: Text(
                              "${radialValue.ceil()} min",
                              style: Theme.of(context).textTheme.headlineMedium,
                            ))
                      ],
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
