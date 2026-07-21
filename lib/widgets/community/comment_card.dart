import 'package:flutter/material.dart';

import '../../app/app_colors.dart';
import '../../models/comment_item.dart';
import '../comment_bubble.dart';
import '../panel.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({
    super.key,
    required this.comment,
    required this.isLiked,
    required this.isReported,
    required this.onLike,
    required this.onReport,
    this.onReply,
    this.replies = const [],
    this.nested = false,
  });

  final CommentItem comment;
  final bool isLiked;
  final bool isReported;
  final VoidCallback onLike;
  final VoidCallback? onReply;
  final VoidCallback? onReport;
  final List<Widget> replies;
  final bool nested;

  @override
  Widget build(BuildContext context) {
    final bubble = CommentBubble(
      initials: comment.initials,
      name: comment.name,
      time: comment.time,
      text: comment.text,
      boxed: nested,
      avatarGap: 10,
      metaStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
      textStyle: const TextStyle(
        color: AppColors.muted,
        fontSize: 12,
        height: 1.45,
      ),
      actions: [
        TextButton(
          key: Key('like-${comment.id}'),
          onPressed: onLike,
          child: Text(
            'ถูกใจ ${comment.likes + (isLiked ? 1 : 0)}',
            style: _toolText.copyWith(
              color: isLiked ? AppColors.campus : AppColors.muted,
            ),
          ),
        ),
        if (onReply != null)
          TextButton(
            key: Key('reply-${comment.id}'),
            onPressed: onReply,
            child: const Text('ตอบกลับ', style: _toolText),
          ),
        TextButton(
          key: Key('report-${comment.id}'),
          onPressed: isReported ? null : onReport,
          child: Text(isReported ? 'รายงานแล้ว' : 'รายงาน', style: _toolText),
        ),
      ],
    );

    if (nested) return bubble;
    return Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          bubble,
          if (replies.isNotEmpty) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 44),
              child: Column(children: replies),
            ),
          ],
        ],
      ),
    );
  }
}

const _toolText = TextStyle(color: AppColors.muted, fontSize: 11);
