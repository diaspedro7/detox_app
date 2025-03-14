import 'dart:typed_data';

import 'package:detox_app/utils/constants/colors.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.appIcon,
    required this.appName,
  });

  final String appName;
  final Uint8List appIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: TSizes.defaultSpace,
        vertical: TSizes.sm,
      ),
      padding: const EdgeInsets.all(TSizes.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
        boxShadow: [
          BoxShadow(
            color: TColors.primary.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(TSizes.sm),
            decoration: BoxDecoration(
              color: TColors.light,
              borderRadius: BorderRadius.circular(TSizes.sm),
            ),
            child: appIcon.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(TSizes.xs),
                    child: Image.memory(
                      appIcon,
                      width: 48,
                      height: 48,
                    ),
                  )
                : const Icon(Icons.android, size: 32, color: Colors.grey),
          ),
          const SizedBox(width: TSizes.spaceBtwItems),
          Text(
            appName,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: TColors.dark,
                ),
          ),
        ],
      ),
    );
  }
}
