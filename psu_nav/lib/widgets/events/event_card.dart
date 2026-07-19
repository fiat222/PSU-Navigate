import 'package:flutter/material.dart';

import '../../app/app_colors.dart';
import '../../models/event_item.dart';
import '../info_card.dart';
import '../right_pill.dart';
import '../small_primary_button.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
    required this.joining,
    required this.onJoin,
  });

  final EventItem event;
  final bool joining;
  final ValueChanged<String> onJoin;

  @override
  Widget build(BuildContext context) {
    final isJoinable = event.actionLabel != null;
    return InfoCard(
      icon: event.icon ?? Icons.event_outlined,
      title: event.title,
      subtitle: event.subtitle,
      trailing: !isJoinable
          ? (event.pillLabel != null ? RightPill(event.pillLabel!) : null)
          : joining
          ? const _MiniSpinner()
          : SmallPrimaryButton(event.actionLabel!, () => onJoin(event.id)),
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

class JoiningBadge extends StatelessWidget {
  const JoiningBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .9),
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
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
