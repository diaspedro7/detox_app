import 'package:detox_app/utils/constants/colors.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  const DeleteButton({
    super.key,
    required this.onPressed,
  });

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(TSizes.twelve),
      ),
      child: IconButton(
        icon: const Icon(
          Icons.delete_outline_rounded,
          // Icons.delete_outline_rounded,
          color: TColors.white,
          size: TSizes.iconMd,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
