import 'package:flutter/material.dart';

import '../app/app_colors.dart';
import '../app/app_theme.dart';
import '../routes/app_routes.dart';
import '../widgets/indoor/floor_plan.dart';
import '../widgets/search_row.dart';
import '../widgets/soft_pill.dart';
import '../widgets/tabs.dart';

class IndoorScreen extends StatelessWidget {
  const IndoorScreen({
    super.key,
    required this.device,
    required this.onSectionChanged,
    required this.onToast,
  });

  final DeviceType device;
  final void Function(String route) onSectionChanged;
  final ValueChanged<String> onToast;

  @override
  Widget build(BuildContext context) {
    final horizontal = device == DeviceType.phone ? 16.0 : 22.0;

    return Column(
      children: [
        SearchRow(
          value: 'ENG-301 ห้องบรรยายรวม',
          leading: Icons.arrow_back,
          onLeading: () => onSectionChanged(AppRoutes.map),
        ),
        const Tabs(
          labels: ['ชั้น 1', 'ชั้น 2', 'ชั้น 3', 'ชั้น 4', 'ชั้น 5'],
          selected: 2,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(horizontal, 0, horizontal, 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.line),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Stack(
                children: [
                  FloorPlanBackground(),
                  RoomBox(
                    label: 'ENG-301',
                    leftPercent: 0.10,
                    topPercent: 0.12,
                    widthPercent: 0.24,
                    heightPercent: 0.18,
                  ),
                  RoomBox(
                    label: 'ENG-302',
                    leftPercent: 0.38,
                    topPercent: 0.12,
                    widthPercent: 0.32,
                    heightPercent: 0.18,
                    hot: true,
                  ),
                  RoomBox(
                    label: 'Lab',
                    leftPercent: 0.74,
                    topPercent: 0.12,
                    widthPercent: 0.20,
                    heightPercent: 0.18,
                  ),
                  RoomBox(
                    label: 'Toilet',
                    leftPercent: 0.10,
                    topPercent: 0.62,
                    widthPercent: 0.27,
                    heightPercent: 0.20,
                  ),
                  RoomBox(
                    label: 'Lift',
                    leftPercent: 0.42,
                    topPercent: 0.62,
                    widthPercent: 0.27,
                    heightPercent: 0.20,
                  ),
                  RoomBox(
                    label: 'Stair',
                    leftPercent: 0.74,
                    topPercent: 0.62,
                    widthPercent: 0.20,
                    heightPercent: 0.20,
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
