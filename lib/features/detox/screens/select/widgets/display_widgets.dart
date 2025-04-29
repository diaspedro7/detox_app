import 'package:detox_app/utils/constants/colors.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:detox_app/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class TitleDisplay extends StatelessWidget {
  const TitleDisplay({
    super.key,
    required this.quantityWidget,
  });

  final Widget quantityWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: TSizes.defaultSpace,
        vertical: TSizes.sm,
      ),
      padding: const EdgeInsets.all(TSizes.md),
      decoration: BoxDecoration(
        color: TColors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
        border: Border.all(color: TColors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                TTexts.chooseYourApps,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: TColors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems / 2),
              quantityWidget
            ],
          ),
          Container(
            padding: const EdgeInsets.all(TSizes.sm),
            decoration: BoxDecoration(
              color: TColors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
            ),
            child: Icon(
              PhosphorIcons.squaresFour(),
              // Icons.apps_rounded,
              size: TSizes.iconLg,
              color: TColors.light,
            ),
          ),
        ],
      ),
    );
  }
}
