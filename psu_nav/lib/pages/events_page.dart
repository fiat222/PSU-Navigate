import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/app_colors.dart';
import '../app/app_theme.dart';
import '../bloc/events/events_bloc.dart';
import '../data/repositories/event_repository.dart';
import '../models/event_item.dart';
import '../widgets/common/loading_indicator.dart';
import '../widgets/common/responsive_list.dart';
import '../widgets/common/skeleton.dart';
import '../widgets/events/event_search_field.dart';
import '../widgets/info_card.dart';
import '../widgets/right_pill.dart';
import '../widgets/small_primary_button.dart';
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
          c.toastMessage != null && c.toastMessage != p.toastMessage,
      listener: (context, state) {
        if (state.toastMessage != null) {
          onToast(state.toastMessage!);
          context.read<EventsBloc>().add(const ToastShown());
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
                  child: _RandomMatchBanner(matching: state.matching),
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
    if (state.matching) {
      return const FullScreenLoading(
        label: 'กำลังสุ่มจับคู่ผู้ใช้ online ใน campus...',
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
            for (final e in state.events) _EventCard(event: e, state: state),
          ],
        ),
        if (state.joining)
          const Positioned(top: 8, right: 8, child: _JoiningBadge()),
      ],
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event, required this.state});

  final EventItem event;
  final EventsState state;

  @override
  Widget build(BuildContext context) {
    final isJoinable = event.actionLabel != null;
    return InfoCard(
      icon: event.icon ?? Icons.event_outlined,
      title: event.title,
      subtitle: event.subtitle,
      trailing: !isJoinable
          ? (event.pillLabel != null ? RightPill(event.pillLabel!) : null)
          : state.joining
          ? const _MiniSpinner()
          : SmallPrimaryButton(
              event.actionLabel!,
              () => context.read<EventsBloc>().add(JoinPlan(event.id)),
            ),
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final tag in event.tags)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.segBg,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '#$tag',
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.softBlue,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'สนใจ ${event.interestedCount} คน',
                style: const TextStyle(
                  color: AppColors.campus,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniSpinner extends StatelessWidget {
  const _MiniSpinner();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(strokeWidth: 2.4),
    );
  }
}

class _JoiningBadge extends StatelessWidget {
  const _JoiningBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .9),
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(strokeWidth: 1.8),
          ),
          SizedBox(width: 6),
          Text(
            'กำลังส่งความสนใจ...',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _RandomMatchBanner extends StatelessWidget {
  const _RandomMatchBanner({required this.matching});

  final bool matching;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
      decoration: BoxDecoration(
        color: AppColors.softBlue,
        border: Border.all(color: AppColors.campus.withValues(alpha: .3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.diversity_3_outlined,
              color: AppColors.campus, size: 18),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'สุ่มจับคู่ผู้ใช้ที่ online ใน campus ตอนนี้',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
          ),
          if (matching)
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            SmallPrimaryButton(
              'จับคู่เลย',
              () => context.read<EventsBloc>().add(const RandomMatch()),
            ),
        ],
      ),
    );
  }
}
