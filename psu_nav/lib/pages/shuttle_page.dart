import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/app_colors.dart';
import '../app/app_theme.dart';
import '../bloc/shuttle/shuttle_bloc.dart';
import '../data/repositories/shuttle_repository.dart';
import '../models/shuttle_route.dart';
import '../widgets/common/error_state.dart';
import '../widgets/common/loading_indicator.dart';
import '../widgets/common/responsive_list.dart';
import '../widgets/info_card.dart';
import '../widgets/right_pill.dart';
import '../widgets/small_primary_button.dart';
import '../widgets/tabs.dart';

class ShuttlePage extends StatelessWidget {
  const ShuttlePage({super.key, required this.device, required this.onToast});

  final DeviceType device;
  final ValueChanged<String> onToast;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) =>
          ShuttleBloc(repo: ctx.read<ShuttleRepository>())
            ..add(const LoadShuttle()),
      child: _ShuttleBody(onToast: onToast, device: device),
    );
  }
}

class _ShuttleBody extends StatelessWidget {
  const _ShuttleBody({required this.onToast, required this.device});

  final ValueChanged<String> onToast;
  final DeviceType device;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShuttleBloc, ShuttleState>(
      listenWhen: (p, c) =>
          c.toastMessage != null && c.toastMessage != p.toastMessage,
      listener: (context, state) {
        if (state.toastMessage != null) {
          onToast(state.toastMessage!);
          context.read<ShuttleBloc>().add(const ToastShown());
        }
      },
      child: BlocBuilder<ShuttleBloc, ShuttleState>(
        builder: (context, state) {
          final labels = state.routes.isEmpty
              ? const ['สาย 1', 'สาย 2', 'สาย 3', 'Saved stop']
              : [...state.routes.map((r) => r.label), 'Saved stop'];
          return Column(
            children: [
              Tabs(
                labels: labels,
                selected: state.selectedIndex.clamp(0, labels.length - 1),
                onTap: (i) {
                  if (i < state.routes.length) {
                    context.read<ShuttleBloc>().add(SelectRoute(i));
                  } else {
                    onToast('Saved stops: ${state.savedStops.join(", ")}');
                  }
                },
              ),
              Expanded(child: _buildBody(context, state)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, ShuttleState state) {
    if (state.loading && state.routes.isEmpty) {
      return const FullScreenLoading(label: 'กำลังโหลดตารางรถ...');
    }
    if (state.errorMessage != null && state.routes.isEmpty) {
      return ErrorState(
        message: state.errorMessage!,
        onRetry: () => context.read<ShuttleBloc>().add(const LoadShuttle()),
      );
    }
    final route = state.currentRoute;
    if (route == null) {
      return const FullScreenLoading(label: 'กำลังเตรียมข้อมูล...');
    }
    const engineeringStop = 'วิศวกรรมศาสตร์ 1';
    final engineeringNotified = state.notifiedStops.contains(engineeringStop);
    return ResponsiveList(
      device: device,
      children: [
        _RouteCard(
          route: route,
          notified: state.notifiedStops,
          onTapStop: (id) =>
              context.read<ShuttleBloc>().add(ToggleStopNotify(id)),
        ),
        InfoCard(
          icon: Icons.notifications_outlined,
          title: 'แจ้งเตือนป้ายประจำ',
          subtitle: 'ติดตามป้ายวิศวกรรมศาสตร์ 1 เฉพาะเซสชันต้นแบบนี้',
          trailing: SmallPrimaryButton(
            engineeringNotified ? 'ปิด' : 'เปิด',
            () => context.read<ShuttleBloc>().add(
              const ToggleStopNotify(engineeringStop),
            ),
            key: const Key('shuttle-engineering-notify'),
          ),
        ),
      ],
    );
  }
}

class _RouteCard extends StatelessWidget {
  const _RouteCard({
    required this.route,
    required this.notified,
    required this.onTapStop,
  });

  final ShuttleRoute route;
  final Set<String> notified;
  final ValueChanged<String> onTapStop;

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      icon: Icons.directions_bus_outlined,
      title: '${route.label} · คันที่ ${route.busNumber}',
      subtitle:
          'จาก${route.from}ไป${route.to}${route.cacheNote != null ? ' · ${route.cacheNote}' : ''}',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RightPill(route.status.label),
          const SizedBox(width: 6),
          RightPill('${route.etaMinutes} นาที'),
        ],
      ),
      child: _Timeline(route: route, notified: notified, onTapStop: onTapStop),
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({
    required this.route,
    required this.notified,
    required this.onTapStop,
  });

  final ShuttleRoute route;
  final Set<String> notified;
  final ValueChanged<String> onTapStop;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < route.stops.length; i++)
          _StopRow(
            stop: route.stops[i],
            isLast: i == route.stops.length - 1,
            isNotified: notified.contains(route.stops[i].name),
            onTap: () => onTapStop(route.stops[i].name),
          ),
      ],
    );
  }
}

class _StopRow extends StatelessWidget {
  const _StopRow({
    required this.stop,
    required this.isLast,
    required this.isNotified,
    required this.onTap,
  });

  final ShuttleStop stop;
  final bool isLast;
  final bool isNotified;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 16,
              child: Column(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: stop.passed ? AppColors.muted : AppColors.campus,
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 28,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      color: AppColors.line,
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                stop.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              stop.time,
              style: const TextStyle(color: AppColors.muted, fontSize: 11),
            ),
            const SizedBox(width: 6),
            if (isNotified)
              const Icon(
                Icons.notifications_active,
                size: 14,
                color: AppColors.campus,
              )
            else
              const Icon(
                Icons.notifications_none,
                size: 14,
                color: AppColors.muted,
              ),
          ],
        ),
      ),
    );
  }
}
