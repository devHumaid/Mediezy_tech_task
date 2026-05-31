import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class ActivityCard extends StatelessWidget {
  final String date;
  final String? markInTime;
  final String? markOutTime;

  const ActivityCard({
    super.key,
    required this.date,
    this.markInTime,
    this.markOutTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
decoration: BoxDecoration(
  color: AppColors.white,
  borderRadius: BorderRadius.circular(12),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      offset: const Offset(-3, 4), // left, bottom
      blurRadius: 8,
      spreadRadius: 1,
    ),
  ],
),
      child: Row(
        children: [
          CircleAvatar(
            radius: 19,
            backgroundColor: AppColors.backgroundLight,
            child: ClipOval(
              child: Image.asset(
                'assets/icons/Vector.png',
                width: 30, height: 30,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(date, style: AppTextStyles.label),
              const SizedBox(height: 0),
              Row(
                children: [
                  Text(
                    'Marked in at ${markInTime ?? "--"}',
                    style: AppTextStyles.recenetactivitytimemaked,
                  ),
                  if (markOutTime != null) ...[
                    const SizedBox(width: 6),
                    const SizedBox(width: 1, height: 10,
                        child: ColoredBox(color: AppColors.divider)),
                    const SizedBox(width: 6),
                    Text(
                      'Marked out at $markOutTime',
                      style: AppTextStyles.recenetactivitytimemaked,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}