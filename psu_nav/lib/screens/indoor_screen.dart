import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/app_colors.dart';
import '../app/app_theme.dart';
import '../bloc/indoor/indoor_bloc.dart';
import '../routes/app_routes.dart';
import '../widgets/indoor/floor_plan.dart';
import '../widgets/search_row.dart';
import '../widgets/soft_pill.dart';

class IndoorScreen extends StatelessWidget {
  const IndoorScreen({
    super.key,
    required this.device,
    required this.onSectionChanged,
    required this.onToast,
  });

  final DeviceType device;
  final SectionNavigator onSectionChanged;
  final ValueChanged<String> onToast;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => IndoorBloc(),
      child: _IndoorBody(
        device: device,
        onSectionChanged: onSectionChanged,
        onToast: onToast,
      ),
    );
  }
}

class _IndoorBody extends StatelessWidget {
  const _IndoorBody({
    required this.device,
    required this.onSectionChanged,
    required this.onToast,
  });

  final DeviceType device;
  final SectionNavigator onSectionChanged;
  final ValueChanged<String> onToast;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IndoorBloc, IndoorState>(
      builder: (context, state) {
        final room = state.selectedRoom;
        return Column(
          children: [
            SearchRow(
              value: room?.code ?? 'ENG-301 ห้องบรรยายรวม',
              leading: Icons.arrow_back,
              onLeading: () => onSectionChanged(AppRoutes.map),
            ),
            _FloorTabs(currentFloor: state.floor),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  device == DeviceType.phone ? 16 : 22,
                  0,
                  device == DeviceType.phone ? 16 : 22,
                  12,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.line),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    children: [
                      const FloorPlanBackground(),
                      for (final r in kIndoorRooms.where(
                        (r) => r.floor == state.floor,
                      ))
                        _positionedRoom(context, r, state.selectedCode),
                    ],
                  ),
                ),
              ),
            ),
            _RoomDetailSheet(room: room),
          ],
        );
      },
    );
  }

  Widget _positionedRoom(BuildContext context, IndoorRoom r, String selected) {
    const layout = <String, ({double l, double t, double w, double h})>{
      'ENG-301': (l: 0.10, t: 0.12, w: 0.24, h: 0.18),
      'ENG-302': (l: 0.38, t: 0.12, w: 0.32, h: 0.18),
      'ENG-LAB1': (l: 0.74, t: 0.12, w: 0.20, h: 0.18),
      'ENG-TOILET': (l: 0.10, t: 0.62, w: 0.27, h: 0.20),
      'ENG-LIFT': (l: 0.42, t: 0.62, w: 0.27, h: 0.20),
      'ENG-STAIR': (l: 0.74, t: 0.62, w: 0.20, h: 0.20),
    };
    final p = layout[r.code];
    if (p == null) return const SizedBox.shrink();
    final hot = r.code == selected;
    return RoomBox(
      key: ValueKey(r.code),
      label: r.code.replaceAll('ENG-', ''),
      leftPercent: p.l,
      topPercent: p.t,
      widthPercent: p.w,
      heightPercent: p.h,
      hot: hot,
      onTap: () => context.read<IndoorBloc>().add(SelectRoom(r.code)),
    );
  }
}

class _FloorTabs extends StatelessWidget {
  const _FloorTabs({required this.currentFloor});

  final int currentFloor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        children: [
          for (var i = 1; i <= 5; i++)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text('ชั้น $i'),
                selected: i == currentFloor,
                onSelected: (_) =>
                    context.read<IndoorBloc>().add(ChangeFloor(i)),
                selectedColor: AppColors.campus,
                labelStyle: TextStyle(
                  color: i == currentFloor ? Colors.white : AppColors.muted,
                  fontWeight: FontWeight.w800,
                ),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                  side: BorderSide(
                    color: i == currentFloor
                        ? AppColors.campus
                        : AppColors.line,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _RoomDetailSheet extends StatelessWidget {
  const _RoomDetailSheet({required this.room});

  final IndoorRoom? room;

  @override
  Widget build(BuildContext context) {
    final r = room;
    if (r == null) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${r.code} · ${r.title}',
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (r.seats != '—') SoftPill(r.seats),
              if (r.facilities != '—') SoftPill(r.facilities),
              SoftPill(r.openHours),
              if (r.rating != '—') SoftPill(r.rating),
            ],
          ),
        ],
      ),
    );
  }
}
