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
        Text(TTexts.appSettings,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: TSizes.twty,
                )),
      ],
    );
  }
}
