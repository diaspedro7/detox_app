import 'package:detox_app/utils/constants/colors.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:detox_app/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';

class TitleDetailsPage extends StatelessWidget {
  const TitleDetailsPage({
    super.key,
    required this.appName,
  });

  final String appName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          TTexts.appSettings,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.7),
              ),
        ),
        SizedBox(
          width: TSizes.textWidth,
          child: Text(
            appName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: TColors.white,
                  fontWeight: FontWeight.bold,
                ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
