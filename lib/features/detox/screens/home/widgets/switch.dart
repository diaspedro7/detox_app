import 'package:detox_app/data/services/time_storage_hive.dart';
import 'package:detox_app/features/detox/statecontrollers/home_page_statecontroller.dart';
import 'package:detox_app/utils/constants/colors.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:provider/provider.dart';

Widget customSwitch(BuildContext context) {
  final stateController =
      Provider.of<HomePageStateController>(context, listen: true);
  return AdvancedSwitch(
    initialValue: getActivateAppService(),
    height: TSizes.switchHeight,
    width: TSizes.switchWidth,
    activeColor: TColors.primary,
    onChanged: (value) {
      stateController.activateAppService(value);
    },
  );
}
