import 'dart:typed_data';

import 'package:detox_app/utils/constants/colors.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.appIcon,
    required this.appName,
    this.color = TColors.neoBackground,
  });

  final String appName;
  final Uint8List appIcon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250.0,
      margin: const EdgeInsets.symmetric(
        horizontal: TSizes.defaultSpace,
        vertical: TSizes.sm,
      ),
      padding: const EdgeInsets.all(TSizes.md),
      decoration: BoxDecoration(
        color: color,
        // color: Colors.white,
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
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
          Flexible(
            child: Text(
              appName,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: TColors.light,
                  ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
