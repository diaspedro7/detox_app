import 'package:detox_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class GradientBackgroundContainer extends StatelessWidget {
  const GradientBackgroundContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              TColors.primary,
              TColors.primary.withValues(alpha: 0.8),
              TColors.backgroundColor,
            ],
            stops: const [0.0, 0.2, 0.4],
          ),
        ),
        child: child);
  }
}
