import 'package:detox_app/features/detox/screens/home/widgets/add_apps_showmodal.dart';
import 'package:detox_app/utils/constants/colors.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class AddAppsWidget extends StatelessWidget {
  const AddAppsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //Navigator.pushNamed(context, "/add");
        showAddAppsModal(context);
      },
      child: Container(
        height: TSizes.addAppsWidget,
        width: TSizes.addAppsWidget,
        decoration: BoxDecoration(
          color: TColors.grey.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(TSizes.twelve),
        ),
        child: const Icon(
          Icons.add_rounded,
          color: TColors.white,
          size: TSizes.appsImage,
        ),
      ),
    );
  }
}
