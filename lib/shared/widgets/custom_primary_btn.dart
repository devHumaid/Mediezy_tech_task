import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double height;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.height = 45,
  });

  @override
  Widget build(BuildContext context) {
    final canTap = onPressed != null && !isLoading;

    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        gradient: canTap ? AppColors.primaryGradient : null,
        color: canTap ? null : const Color(0xFFBDBDBD),
        borderRadius: BorderRadius.circular(30),
      ),
      child: ElevatedButton(
        onPressed: canTap ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22, height: 22,
                child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2),
              )
            : Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: canTap ? AppColors.white : Colors.white70,
                ),
              ),
      ),
    );
  }
}