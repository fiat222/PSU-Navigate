import 'package:flutter/material.dart';

import '../../app/app_colors.dart';

class CampusMapBackground extends StatelessWidget {
  const CampusMapBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: const CampusMapPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class CampusMapPainter extends CustomPainter {
  const CampusMapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(AppColors.softMap, BlendMode.src);
    final grid = Paint()
      ..color = Colors.white.withValues(alpha: .44)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 44) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y < size.height; y += 44) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final road = Paint()
      ..color = AppColors.road
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * .08, size.height * .88),
      Offset(size.width * .85, size.height * .18),
      road,
    );
    canvas.drawLine(
      Offset(size.width * .12, size.height * .28),
      Offset(size.width * .95, size.height * .78),
      road,
    );

    final myLocDot = Paint()..color = AppColors.campus3;
    canvas.drawCircle(Offset(size.width * .22, size.height * .52), 6, myLocDot);
    canvas.drawCircle(
      Offset(size.width * .22, size.height * .52),
      16,
      Paint()..color = AppColors.campus3.withValues(alpha: .22),
    );

    final lake = Paint()..color = AppColors.lake;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * .76, size.height * .18),
        width: size.width * .28,
        height: size.height * .18,
      ),
      lake,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
