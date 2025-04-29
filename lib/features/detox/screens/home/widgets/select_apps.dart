import 'package:detox_app/utils/constants/colors.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:detox_app/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SelectApps extends StatelessWidget {
  const SelectApps({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TSizes.md),
      ),
      child: Padding(
        padding: const EdgeInsets.all(TSizes.md),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              TTexts.selectApps,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Padding(
              padding: const EdgeInsets.only(right: TSizes.ten),
              child: Icon(
                PhosphorIcons.plus(),
                // Icons.add_rounded,
                size: TSizes.iconMd,
                color: TColors.light,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
