import 'package:flutter/material.dart';

import '../app/app_colors.dart';

class MiniIcon extends StatelessWidget {
  const MiniIcon(this.icon, {super.key});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: const Color(0xFFE9F2FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: AppColors.campus, size: 18),
    );
  }
}
