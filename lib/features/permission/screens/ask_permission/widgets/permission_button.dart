import 'package:detox_app/features/permission/viewmodel/permission_viewmodel.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PermissionButton extends StatelessWidget {
  const PermissionButton(
      {super.key, required this.onPressed, required this.permissionText});

  final void Function()? onPressed;
  final String permissionText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(permissionText
            // "Allow app usage access to monitor your screen time.",
            ),
        const SizedBox(height: TSizes.sm),
        Consumer<PermissionViewModel>(
          builder: (context, controller, child) => SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: onPressed,
                style: Theme.of(context).elevatedButtonTheme.style,
                child: const Text(
                  "Accept",
                )),
          ),
        ),
      ],
    );
  }
}
