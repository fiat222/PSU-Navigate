import 'package:flutter/material.dart';

import '../../app/app_colors.dart';
import '../../app/app_theme.dart';

class FloorPlanBackground extends StatelessWidget {
  const FloorPlanBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned.fill(
      child: CustomPaint(painter: FloorPlanPainter()),
    );
  }
}

class FloorPlanPainter extends CustomPainter {
  const FloorPlanPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.floorStroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18;
    final rect = Rect.fromLTWH(28, 88, size.width - 56, 70);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class RoomBox extends StatelessWidget {
  const RoomBox({
    super.key,
    required this.label,
    required this.leftPercent,
    required this.topPercent,
    required this.widthPercent,
    required this.heightPercent,
    this.hot = false,
    this.onTap,
  });

  final String label;
  final double leftPercent;
  final double topPercent;
  final double widthPercent;
  final double heightPercent;
  final bool hot;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth * widthPercent;
        final h = constraints.maxHeight * heightPercent;
        return Positioned(
          left: constraints.maxWidth * leftPercent,
          top: constraints.maxHeight * topPercent,
          width: w,
          height: h,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: Material(
                  color: hot ? AppColors.roomHot : AppColors.softRoom,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: hot ? AppColors.campus : AppColors.roomIdle,
                    ),
                    borderRadius: BorderRadius.circular(AppLayout.radiusSm),
                  ),
                  child: InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(AppLayout.radiusSm),
                    child: Center(
                      child: Text(
                        label,
                        style: TextStyle(
                          color: hot ? AppColors.campus : AppColors.muted,
                          fontSize: 11,
                          fontWeight: hot ? FontWeight.w900 : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (hot) const Positioned(top: -6, right: -6, child: _HotDot()),
            ],
          ),
        );
      },
    );
  }
}

class _HotDot extends StatelessWidget {
  const _HotDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: AppColors.alert,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.alert.withValues(alpha: .14),
            spreadRadius: 5,
          ),
        ],
      ),
    );
  }
}
