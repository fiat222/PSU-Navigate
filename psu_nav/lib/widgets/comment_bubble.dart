import 'package:flutter/material.dart';

import '../app/app_colors.dart';
import 'avatar.dart';

class CommentBubble extends StatelessWidget {
  const CommentBubble({
    super.key,
    required this.initials,
    required this.name,
    required this.time,
    required this.text,
    this.actions = const [],
    this.boxed = true,
    this.avatarGap = 8,
    this.metaStyle = const TextStyle(
      fontWeight: FontWeight.w800,
      fontSize: 11,
    ),
    this.textStyle = const TextStyle(
      color: AppColors.muted,
      fontSize: 11,
      height: 1.4,
    ),
    this.contentPadding = const EdgeInsets.all(10),
    this.maxLines,
    this.overflow,
    this.actionSpacing = 12,
  });

  final String initials;
  final String name;
  final String time;
  final String text;
  final List<Widget> actions;
  final bool boxed;
  final double avatarGap;
  final TextStyle metaStyle;
  final TextStyle textStyle;
  final EdgeInsetsGeometry contentPadding;
  final int? maxLines;
  final TextOverflow? overflow;
  final double actionSpacing;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$name · $time', style: metaStyle),
        const SizedBox(height: 4),
        Text(
          text,
          maxLines: maxLines,
          overflow: overflow,
          style: textStyle,
        ),
        if (actions.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(spacing: actionSpacing, children: actions),
        ],
      ],
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Avatar(initials),
        SizedBox(width: avatarGap),
        Expanded(
          child: boxed
              ? Container(
                  padding: contentPadding,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F8FC),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: content,
                )
              : content,
        ),
      ],
    );
  }
}
