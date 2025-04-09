import 'package:detox_app/features/detox/viewmodels/home_page_viewmodel.dart';
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
        Consumer<HomePageViewModel>(
          builder: (context, viewmodel, child) => Text(
            viewmodel.isActivated ? TTexts.enabled : TTexts.disabled,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: viewmodel.isActivated
                      ? TColors.primary
                      : TColors.darkGrey,
                ),
          ),
        )
      ],
    );
  }
}
