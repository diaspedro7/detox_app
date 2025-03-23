import 'package:detox_app/features/detox/statecontrollers/home_page_statecontroller.dart';
import 'package:detox_app/utils/constants/colors.dart';
import 'package:detox_app/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SwitchText extends StatelessWidget {
  const SwitchText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          TTexts.detoxModeIs,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Consumer<HomePageStateController>(
          builder: (context, stateController, child) => Text(
            stateController.isActivated ? TTexts.enabled : TTexts.disabled,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: stateController.isActivated
                      ? TColors.primary
                      : TColors.darkGrey,
                ),
          ),
        )
      ],
    );
  }
}
