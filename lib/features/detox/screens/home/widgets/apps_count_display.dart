import 'package:detox_app/utils/constants/colors.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class AppsCounterDisplay extends StatelessWidget {
  const AppsCounterDisplay({
    super.key,
    required this.quantity,
  });

  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: TSizes.md,
        vertical: TSizes.sm,
      ),
      decoration: BoxDecoration(
        color: TColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
        border: Border.all(
          color: TColors.primary.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.apps_rounded,
            color: TColors.primary.withValues(alpha: 0.8),
            size: 20,
          ),
          const SizedBox(width: TSizes.xs),
          Text(
            '$quantity apps monitored',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: TColors.primary.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}
