import 'package:flutter/material.dart' hide IconButton;

import '../app/app_colors.dart';

class IconButton extends StatelessWidget {
  const IconButton({super.key, required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.line),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.ink, size: 18),
      ),
    );
  }
}
