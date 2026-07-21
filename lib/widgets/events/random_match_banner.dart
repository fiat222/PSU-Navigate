import 'package:flutter/material.dart';

import '../../app/app_colors.dart';
import '../small_primary_button.dart';

class RandomMatchBanner extends StatelessWidget {
  const RandomMatchBanner({
    super.key,
    required this.matching,
    required this.onMatch,
  });

  final bool matching;
  final VoidCallback onMatch;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
      decoration: BoxDecoration(
        color: AppColors.softBlue,
        border: Border.all(color: AppColors.campus.withValues(alpha: .3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.diversity_3_outlined,
            color: AppColors.campus,
            size: 18,
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'สุ่มจับคู่จากข้อมูลผู้ใช้ตัวอย่างใน prototype',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
          ),
          if (matching)
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            SmallPrimaryButton('จับคู่เลย', onMatch),
        ],
      ),
    );
  }
}
