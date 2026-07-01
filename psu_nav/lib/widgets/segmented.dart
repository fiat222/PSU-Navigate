import 'package:flutter/material.dart';

import '../app/app_colors.dart';

class Segmented extends StatelessWidget {
  const Segmented({super.key, required this.labels, required this.selected});

  final List<String> labels;
  final int selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 9),
                color: i == selected ? AppColors.campus : Colors.transparent,
                alignment: Alignment.center,
                child: Text(
                  labels[i],
                  style: TextStyle(
                    color: i == selected ? Colors.white : AppColors.muted,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
