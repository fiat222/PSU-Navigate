import 'package:flutter/material.dart';

import '../../app/app_colors.dart';
import '../../app/app_theme.dart';
import '../../models/place_discussion.dart';

class FacultyPicker extends StatelessWidget {
  const FacultyPicker({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.highlightError = false,
  });

  final PlaceCategory? value;
  final ValueChanged<PlaceCategory?> onChanged;
  final bool enabled;
  final bool highlightError;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'คณะ',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppLayout.radiusMd),
            border: Border.all(
              color: (highlightError && value == null)
                  ? AppColors.alert
                  : AppColors.line,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<PlaceCategory>(
              value: value,
              isExpanded: true,
              iconEnabledColor: AppColors.muted,
              hint: const Text(
                'เลือกคณะของคุณ',
                style: TextStyle(color: AppColors.muted, fontSize: 13),
              ),
              items: [
                for (final c in PlaceCategory.values)
                  DropdownMenuItem(
                    value: c,
                    child: Row(
                      children: [
                        Icon(c.icon, size: 16, color: AppColors.campus),
                        const SizedBox(width: 8),
                        Text(
                          c.label,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
              onChanged: enabled ? onChanged : null,
            ),
          ),
        ),
      ],
    );
  }
}
