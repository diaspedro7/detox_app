import 'package:detox_app/features/detox/models/app_model.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class AppHomeTile extends StatelessWidget {
  const AppHomeTile({super.key, required this.app});

  final AppModel app;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: TSizes.addAppsWidget,
      padding: const EdgeInsets.symmetric(
          // vertical: TSizes.twelve,
          horizontal: TSizes.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TSizes.twelve),
        boxShadow: const [
          // BoxShadow(
          //   color: Colors.black.withValues(alpha: 0.05),
          //   blurRadius: TSizes.sm,
          //   offset: const Offset(0, TSizes.appsImage / 2),
          // ),
        ],
      ),
      child: Row(
        children: [
          app.appIcon.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(TSizes.sm),
                  child: Image.memory(
                    app.appIcon,
                    width: TSizes.appsImage,
                    height: TSizes.appsImage,
                  ),
                )
              : const Icon(Icons.android,
                  size: TSizes.appsImage, color: Colors.grey),
          const SizedBox(width: TSizes.twelve),
          Expanded(
            child: Text(
              app.appName,
              style: Theme.of(context).textTheme.titleSmall,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          )
        ],
      ),
    );
  }
}
