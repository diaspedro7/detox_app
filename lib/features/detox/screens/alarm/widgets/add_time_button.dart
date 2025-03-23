import 'package:detox_app/utils/constants/sizes.dart';
import 'package:detox_app/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';

class AddTimeButton extends StatelessWidget {
  const AddTimeButton({
    super.key,
    required this.minutes,
    this.onPressed,
  });

  final String minutes;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:
          (MediaQuery.of(context).size.width - TSizes.lg * 2 - TSizes.sm) / 2,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white, width: 1),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: TSizes.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TSizes.buttonRadius),
          ),
        ),
        child: Text(
          "$minutes ${TTexts.minAbv}",
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
