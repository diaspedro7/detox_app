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
