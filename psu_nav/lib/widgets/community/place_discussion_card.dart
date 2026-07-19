import 'package:flutter/material.dart';

import '../../app/app_colors.dart';
import '../avatar.dart';
import '../comment_bubble.dart';
import '../info_card.dart';
import '../mini_icon.dart';
import '../panel.dart';
import '../right_pill.dart';
import '../../models/place_discussion.dart';

class PlaceDiscussionCard extends StatelessWidget {
  const PlaceDiscussionCard({
    super.key,
    required this.place,
    required this.onTap,
  });

  final PlaceDiscussion place;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final previewComments = place.comments.take(2).toList();
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MiniIcon(place.icon),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.star,
                            color: AppColors.sun,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              place.subtitle,
                              style: const TextStyle(
                                color: AppColors.muted,
                                fontSize: 12,
                                height: 1.45,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RightPill(place.ratingLabel),
                    const SizedBox(height: 8),
                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.muted,
                      size: 18,
                    ),
                  ],
                ),
              ],
            ),
            if (previewComments.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                'รีวิวล่าสุด',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              for (final comment in previewComments)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: CommentBubble(
                    initials: comment.initials,
                    name: comment.name,
                    time: comment.time,
                    text: comment.text,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class ModerationCard extends StatelessWidget {
  const ModerationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.softWarn,
        border: Border.all(color: AppColors.alert.withValues(alpha: .32)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Avatar('--'),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ระบบตรวจจับ',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  'คอมเมนต์หนึ่งถูกซ่อนชั่วคราว เพราะ dislike/report สูงผิดปกติ รอ admin ตรวจสอบ',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  children: [
                    Text('auto moderation', style: _toolText),
                    Text('อัปเดตจาก mock state', style: _toolText),
                  ],
                ),
              ],
            ),
          ),
          RightPill('hidden', alert: true),
        ],
      ),
    );
  }
}

class PlaceHeader extends StatelessWidget {
  const PlaceHeader({super.key, required this.place});

  final PlaceDiscussion place;

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      icon: place.icon,
      title: place.name,
      subtitle: place.subtitle,
      trailing: RightPill(place.ratingLabel),
    );
  }
}

const _toolText = TextStyle(color: AppColors.muted, fontSize: 11);
