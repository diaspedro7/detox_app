import 'package:detox_app/utils/constants/colors.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:detox_app/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';

class HomeTitle extends StatelessWidget {
  const HomeTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.psychology_outlined,
              color: TColors.primary,
              size: TSizes.iconLg,
            ),
            const SizedBox(width: TSizes.sm),
            Text(
              TTexts.appName,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: TColors.primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
            ),
          ],
        ),
        const SizedBox(height: TSizes.sm),
        Text(
          TTexts.slogan,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: TColors.primary.withValues(alpha: 0.7),
                letterSpacing: 0.5,
              ),
        ),
      ],
    );
  }
}
