import 'package:detox_app/common/widgets/custom_icon_button.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:detox_app/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';

class TitleAlarmPage extends StatelessWidget {
  const TitleAlarmPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(child: SizedBox()), // Espaço à esquerda
              Icon(
                Icons.timer_off_rounded,
                size: TSizes.titleIcon,
                color: Colors.white.withValues(alpha: 0.9),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: CustomIconButton(
                        icon: Icons.home_filled,
                        onPressed: () =>
                            Navigator.pushReplacementNamed(context, "/home")),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems / 2),
          Text(
            TTexts.timesUp,
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Text(
            TTexts.reachedUsageLimit,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: TSizes.ten),
          Text(
            TTexts.chooseOptions,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w500,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
