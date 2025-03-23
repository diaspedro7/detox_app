import 'package:detox_app/utils/constants/sizes.dart';
import 'package:detox_app/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  const CustomCircularProgressIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(TSizes.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(TSizes.twelve),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(TSizes.md),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: TSizes.ten,
                  offset: const Offset(2, 2),
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.8),
                  blurRadius: TSizes.sm,
                  offset: const Offset(-2, -2),
                ),
              ],
            ),
            child: const CircularProgressIndicator(
              color: Colors.blueAccent,
              strokeWidth: TSizes.xs,
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Text(TTexts.loading, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
