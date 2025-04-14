import 'package:detox_app/data/repositories/time_storage_repository.dart';
import 'package:detox_app/features/detox/viewmodels/home_page_viewmodel.dart';
import 'package:detox_app/utils/constants/colors.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:provider/provider.dart';

Widget customSwitch(BuildContext context) {
  final timeStorage = context.read<TimeStorageRepository>();

  final viewmodel = Provider.of<HomePageViewModel>(context, listen: true);
  return AdvancedSwitch(
    initialValue: timeStorage.getActivateAppService(),
    height: TSizes.switchHeight,
    width: TSizes.switchWidth,
    activeColor: TColors.primary,
    onChanged: (value) {
      viewmodel.activateAppService(value);
    },
  );
}
