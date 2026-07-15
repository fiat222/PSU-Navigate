import 'package:flutter/material.dart';

import '../../app/app_colors.dart';
import '../../app/app_theme.dart';

class MapLabel extends StatelessWidget {
  const MapLabel({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .86),
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(AppLayout.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
          ),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

class MapPin extends StatelessWidget {
  const MapPin({
    super.key,
    required this.leftPercent,
    required this.topPercent,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final double leftPercent;
  final double topPercent;
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const pinSize = 34.0;
        final labelWidth = label.length * 7.0 + 14;
        final cx = constraints.maxWidth * leftPercent;
        final cy = constraints.maxHeight * topPercent;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: cx - pinSize / 2,
              top: cy - pinSize / 2,
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  width: pinSize,
                  height: pinSize,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: .30),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 18),
                ),
              ),
            ),
            Positioned(
              left: cx - labelWidth / 2,
              top: cy + pinSize / 2 + 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.line),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(label, style: const TextStyle(fontSize: 10)),
              ),
            ),
          ],
        );
      },
    );
  }
}
