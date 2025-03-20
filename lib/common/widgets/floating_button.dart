import 'package:detox_app/utils/constants/colors.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({
    super.key,
    required Animation<double> fadeAnimation,
    required this.onPressed,
    required this.buttonText,
  }) : _fadeAnimation = fadeAnimation;

  final Animation<double> _fadeAnimation;
  final String buttonText;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _fadeAnimation,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              TColors.primary,
              TColors.primary.withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
          boxShadow: [
            BoxShadow(
              color: TColors.primary.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () async {
            onPressed();
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          label: Padding(
            padding: const EdgeInsets.symmetric(horizontal: TSizes.sm),
            child: Text(
              buttonText,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: TColors.white,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          icon: const Icon(Icons.check_rounded, color: TColors.white),
        ),
      ),
    );
  }
}
