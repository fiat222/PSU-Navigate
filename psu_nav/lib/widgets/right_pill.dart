import 'package:flutter/material.dart';

import '../app/app_colors.dart';

class RightPill extends StatelessWidget {
  const RightPill(this.label, {super.key, this.alert = false});

  final String label;
  final bool alert;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: alert ? const Color(0xFFFDECEA) : const Color(0xFFEEF5F8),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: alert ? AppColors.alert : AppColors.campus2,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
