import 'package:detox_app/utils/constants/colors.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:detox_app/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';

class AppCurrentTimeDisplay extends StatelessWidget {
  const AppCurrentTimeDisplay({
    super.key,
    required this.time,
  });
  final int time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      decoration: BoxDecoration(
        color: TColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(TSizes.twty),
        border: Border.all(
          color: TColors.primary.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          Text(
            TTexts.currentLimit,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: TColors.primary.withValues(alpha: 0.7),
                ),
          ),
          const SizedBox(height: TSizes.sm),
          Text(
            "$time ${TTexts.minAbv}",
            // "${detailsPageStateController.getLimitTime(widget.app.appPackageName)} min",
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: TColors.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
