import 'package:flutter/material.dart' hide IconButton;

import '../../app/app_colors.dart';
import '../icon_button.dart';

class CommunityDetailToolbar extends StatelessWidget {
  const CommunityDetailToolbar({
    super.key,
    required this.placeName,
    required this.onBack,
    required this.onRate,
    this.sessionRating,
  });

  final String placeName;
  final VoidCallback onBack;
  final VoidCallback onRate;
  final int? sessionRating;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(icon: Icons.arrow_back, onTap: onBack),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 42,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.line),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    placeName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.ink),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                key: const Key('community-rate-place'),
                icon: sessionRating == null ? Icons.star_border : Icons.star,
                onTap: onRate,
              ),
            ],
          ),
          if (sessionRating != null) ...[
            const SizedBox(height: 8),
            Text(
              'คะแนน session นี้: $sessionRating ดาว',
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
