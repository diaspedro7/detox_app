import 'package:detox_app/utils/constants/colors.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class SelectApps extends StatelessWidget {
  const SelectApps({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: TColors.white,
        borderRadius: BorderRadius.circular(TSizes.md),
      ),
      child: Padding(
        padding: const EdgeInsets.all(TSizes.md),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Select Apps",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Padding(
              padding: EdgeInsets.only(right: TSizes.ten),
              child: Icon(
                Icons.chevron_right,
                size: TSizes.iconMd,
                // size: TSizes.iconSm,
                color: TColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
