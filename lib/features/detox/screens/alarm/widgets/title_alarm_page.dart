import 'package:detox_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class TitleAlarmPage extends StatelessWidget {
  const TitleAlarmPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(
          Icons.timer_off_rounded,
          size: 80,
          color: Colors.white,
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        Text(
          "Time's Up!",
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: TSizes.sm),
        Text(
          "You've reached your app usage limit",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
