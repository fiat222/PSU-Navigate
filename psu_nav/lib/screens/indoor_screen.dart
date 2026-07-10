import 'package:flutter/material.dart';

import '../app/app_colors.dart';
import '../routes/app_routes.dart';
import '../widgets/search_row.dart';
import '../widgets/soft_pill.dart';
import '../widgets/tabs.dart';

class IndoorScreen extends StatelessWidget {
  const IndoorScreen({
    super.key,
    required this.desktop,
    required this.onSectionChanged,
    required this.onToast,
  });

  final bool desktop;
  final void Function(String route) onSectionChanged;
  final ValueChanged<String> onToast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchRow(
          value: 'ENG-301 ห้องบรรยายรวม',
          leading: Icons.arrow_back,
          onLeading: () => onSectionChanged(AppRoutes.map),
        ),
        Tabs(
          labels: const ['ชั้น 1', 'ชั้น 2', 'ชั้น 3', 'ชั้น 4', 'ชั้น 5'],
          selected: 2,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              desktop ? 22 : 16,
              0,
              desktop ? 22 : 16,
              12,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.line),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: const [
                  _FloorPlanBase(),
                  _RoomBox(
                    label: 'ENG-301',
                    left: 34,
                    top: 34,
                    width: 84,
                    height: 50,
                  ),
                  _RoomBox(
                    label: 'ENG-302',
                    left: 132,
                    top: 34,
                    width: 112,
                    height: 50,
                    hot: true,
                  ),
                  _RoomBox(
                    label: 'Lab',
                    left: 258,
                    top: 34,
                    width: 72,
                    height: 50,
                  ),
                  _RoomBox(
                    label: 'Toilet',
                    left: 34,
                    top: 178,
                    width: 96,
                    height: 56,
                  ),
                  _RoomBox(
                    label: 'Lift',
                    left: 144,
                    top: 178,
                    width: 96,
                    height: 56,
                  ),
                  _RoomBox(
                    label: 'Stair',
                    left: 254,
                    top: 178,
                    width: 76,
                    height: 56,
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: AppColors.line)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ENG-302 · ห้องบรรยายรวม',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  SoftPill('120 ที่นั่ง'),
                  SoftPill('Projector + AC'),
                  SoftPill('08:00-17:00'),
                  SoftPill('rating 4.6'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FloorPlanBase extends StatelessWidget {
  const _FloorPlanBase();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(child: CustomPaint(painter: _FloorPlanPainter()));
  }
}

class _FloorPlanPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFEDF3FB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18;
    final rect = Rect.fromLTWH(28, 88, size.width - 56, 70);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RoomBox extends StatelessWidget {
  const _RoomBox({
    required this.label,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    this.hot = false,
  });

  final String label;
  final double left;
  final double top;
  final double width;
  final double height;
  final bool hot;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: hot ? const Color(0xFFEAF2FF) : const Color(0xFFFBFDFF),
                border: Border.all(
                  color: hot ? AppColors.campus : const Color(0xFFCBD7E6),
                ),
                borderRadius: BorderRadius.circular(6),
              ),
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
          if (hot)
            Positioned(
              top: -6,
              right: -6,
              child: Container(
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
              ),
            ),
        ],
      ),
    );
  }
}
