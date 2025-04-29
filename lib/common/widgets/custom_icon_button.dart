import 'package:detox_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.iconSize = 20,
  });

  final void Function() onPressed;
  final IconData icon;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        // color: Colors.white.withValues(alpha: 0.2),
        // borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: IconButton(
          icon: Icon(icon, color: TColors.white, size: iconSize),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
