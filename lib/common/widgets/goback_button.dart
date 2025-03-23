import 'package:detox_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class GoBackButton extends StatelessWidget {
  const GoBackButton({
    super.key,
    required this.onPressed,
  });

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new,
            color: TColors.white, size: 20),
        onPressed: onPressed,
      ),
    );
  }
}
