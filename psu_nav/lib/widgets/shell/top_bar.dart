import 'package:flutter/material.dart';

import '../../app/app_colors.dart';
import '../../app/app_theme.dart';

class LiveDot extends StatelessWidget {
  const LiveDot({super.key, required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? AppColors.success : AppColors.muted,
        shape: BoxShape.circle,
        boxShadow: [
          if (active)
            BoxShadow(
              color: AppColors.success.withValues(alpha: .35),
              blurRadius: 6,
              spreadRadius: 1,
            ),
        ],
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    required this.subtitle,
    required this.notificationsEnabled,
    required this.onToggleNotifications,
    required this.onNotifyPressed,
  });

  final String subtitle;
  final bool notificationsEnabled;
  final VoidCallback onToggleNotifications;
  final VoidCallback onNotifyPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
      decoration: const BoxDecoration(
        color: AppColors.topBar,
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppLayout.radiusLg - 2),
              gradient: const LinearGradient(
                colors: [AppColors.campus, AppColors.deepBlue],
              ),
            ),
            child: const Center(
              child: Text(
                'PSU',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  letterSpacing: .4,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Campus Navigator',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                ),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: const TextStyle(color: AppColors.muted, fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          LiveDot(active: notificationsEnabled),
          const SizedBox(width: 8),
          NotificationToggleButton(
            active: notificationsEnabled,
            onToggle: onToggleNotifications,
            onPressed: onNotifyPressed,
          ),
        ],
      ),
    );
  }
}

class NotificationToggleButton extends StatelessWidget {
  const NotificationToggleButton({
    super.key,
    required this.active,
    required this.onToggle,
    required this.onPressed,
  });

  final bool active;
  final VoidCallback onToggle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onToggle,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppLayout.radiusMd),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: active ? AppColors.softBlue : Colors.white,
            border: Border.all(
              color: active ? AppColors.campus : AppColors.line,
            ),
            borderRadius: BorderRadius.circular(AppLayout.radiusMd),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                active ? Icons.notifications : Icons.notifications_off_outlined,
                color: active ? AppColors.campus : AppColors.muted,
                size: 18,
              ),
              if (active)
                const Positioned(top: 5, right: 5, child: _ActiveBadge()),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActiveBadge extends StatelessWidget {
  const _ActiveBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: AppColors.alert,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.4),
      ),
    );
  }
}
