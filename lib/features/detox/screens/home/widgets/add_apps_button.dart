import 'package:detox_app/features/detox/screens/home/widgets/add_apps_showmodal.dart';
import 'package:detox_app/utils/constants/colors.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AddAppsWidget extends StatelessWidget {
  const AddAppsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
        color: TColors.neoBackground,
        borderRadius: BorderRadius.circular(TSizes.twelve),
        child: InkWell(
          borderRadius: BorderRadius.circular(TSizes.twelve),
          onTap: () {
            //Navigator.pushNamed(context, "/add");
            showAddAppsModal(context);
          },
          child: Container(
            height: TSizes.addAppsWidget,
            width: TSizes.addAppsWidget,
            decoration: BoxDecoration(
              // color: TColors.darkerGrey,
              // color: Colors.grey[800],
              // color: TColors.grey.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(TSizes.twelve),
            ),
            // child: PhosphorIcon(
            //   PhosphorIcons.plus(),
            //   color: TColors.white,
            //   size: TSizes.appsImage,
            // ),
            child: Icon(
              // Icons.add_rounded,
              PhosphorIcons.listPlus(),
              // PhosphorIcons.plus(),
              // color: TColors.black,
              color: TColors.white,
              size: TSizes.addIcon,
            ),
          ),
        ));
  }
}
