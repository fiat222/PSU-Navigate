import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/app_theme.dart';
import '../bloc/events/events_bloc.dart';
import '../data/repositories/event_repository.dart';
import '../widgets/common/error_state.dart';
import '../widgets/common/loading_indicator.dart';
import '../widgets/common/responsive_list.dart';
import '../widgets/common/skeleton.dart';
import '../widgets/events/event_card.dart';
import '../widgets/events/event_search_field.dart';
import '../widgets/events/random_match_banner.dart';
import '../widgets/tabs.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key, required this.device, required this.onToast});

  final DeviceType device;
  final ValueChanged<String> onToast;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) =>
          EventsBloc(repo: ctx.read<EventRepository>())
            ..add(const LoadEvents()),
      child: _EventsBody(onToast: onToast, device: device),
    );
  }
}

class _EventsBody extends StatelessWidget {
  const _EventsBody({required this.onToast, required this.device});

  final ValueChanged<String> onToast;
  final DeviceType device;

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventsBloc, EventsState>(
      listenWhen: (p, c) =>
          (c.toastMessage != null && c.toastMessage != p.toastMessage) ||
          (c.errorMessage != null &&
              c.errorMessage != p.errorMessage &&
              c.allEvents.isNotEmpty),
      listener: (context, state) {
        if (state.toastMessage != null) {
          onToast(state.toastMessage!);
          context.read<EventsBloc>().add(const ToastShown());
        }
        if (state.errorMessage != null && state.allEvents.isNotEmpty) {
          onToast(state.errorMessage!);
          context.read<EventsBloc>().add(const ClearEventsError());
        }
      },
      child: BlocBuilder<EventsBloc, EventsState>(
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: EventSearchField(
                  value: state.query,
                  onChanged: (q) =>
                      context.read<EventsBloc>().add(SearchEvents(q)),
                ),
              ),
              Tabs(
                labels: const ['วันนี้', 'สัปดาห์นี้', 'Plan', 'Activity'],
                selected: state.tab.index,
                onTap: (i) => context.read<EventsBloc>().add(
                  ChangeTab(EventsTab.values[i]),
                ),
              ),
              if (state.tab == EventsTab.plan)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: RandomMatchBanner(
                    matching: state.matching,
                    onMatch: () =>
                        context.read<EventsBloc>().add(const RandomMatch()),
                  ),
                ),
              Expanded(child: _buildBody(context, state)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, EventsState state) {
    if (state.loading) {
      return const FullScreenLoading(label: 'กำลังโหลดกิจกรรม...');
    }
    if (state.errorMessage != null && state.allEvents.isEmpty) {
      return ErrorState(
        message: state.errorMessage!,
        onRetry: () => context.read<EventsBloc>().add(const LoadEvents()),
      );
    }
    if (state.matching) {
      return const FullScreenLoading(
        label: 'กำลังสุ่มจากข้อมูลผู้ใช้ตัวอย่าง...',
      );
    }
    if (state.events.isEmpty) {
      return const EmptyState(
        icon: Icons.event_busy_outlined,
        title: 'ไม่มีกิจกรรมในหมวดนี้',
        subtitle: 'ลองเปลี่ยนแท็บหรือเคลียร์คำค้น',
      );
    }
    return Stack(
      children: [
        ResponsiveList(
          device: device,
          children: [
            for (final event in state.events)
              EventCard(
                event: event,
                joining: state.joining,
                onJoin: (eventId) =>
                    context.read<EventsBloc>().add(JoinPlan(eventId)),
              ),
          ],
        ),
        if (state.joining)
          const Positioned(top: 8, right: 8, child: JoiningBadge()),
      ],
    );
  }
}
