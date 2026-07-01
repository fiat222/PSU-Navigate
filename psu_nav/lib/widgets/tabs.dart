import 'package:flutter/material.dart';

import '../app/app_colors.dart';

class Tabs extends StatelessWidget {
  const Tabs({super.key, required this.labels, required this.selected});

  final List<String> labels;
  final int selected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final active = index == selected;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: active ? AppColors.campus : Colors.white,
              border: Border.all(
                color: active ? AppColors.campus : AppColors.line,
              ),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              labels[index],
              style: TextStyle(
                color: active ? Colors.white : AppColors.muted,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        },
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemCount: labels.length,
      ),
    );
  }
}
