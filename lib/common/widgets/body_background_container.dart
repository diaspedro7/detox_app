import 'package:detox_app/utils/constants/colors.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class BodyBackgroundContainer extends StatelessWidget {
  const BodyBackgroundContainer({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: TSizes.spaceBtwItems),
      decoration: BoxDecoration(
        color: TColors.dark,
        // color: TColors.backgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(25.0),
          // top: Radius.circular(TSizes.cardRadiusLg),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: child,
    );
  }
}
