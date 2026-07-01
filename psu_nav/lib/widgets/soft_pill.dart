import 'package:flutter/material.dart';

import '../app/app_colors.dart';

class SoftPill extends StatelessWidget {
  const SoftPill(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F5FB),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(color: AppColors.muted, fontSize: 11),
      ),
    );
  }
}
