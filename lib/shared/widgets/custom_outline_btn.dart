import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AppOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double height;

  const AppOutlineButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = 45,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryDark,
          side: const BorderSide(color: AppColors.primaryDark, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryDark,
          ),
        ),
      ),
    );
  }
}