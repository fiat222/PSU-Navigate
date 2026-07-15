import 'package:flutter/material.dart';

import '../../app/app_colors.dart';
import '../../app/app_theme.dart';
import '../../routes/app_routes.dart';
import '../../routes/route_generator.dart';
import '../common/loading_indicator.dart';
import 'bottom_nav.dart';
import 'top_bar.dart';

class PrototypeShell extends StatelessWidget {
  const PrototypeShell({
    super.key,
    required this.currentRoute,
    required this.device,
    required this.onNavigate,
    required this.onToast,
    required this.isTransitioning,
    required this.notificationsEnabled,
    required this.onToggleNotifications,
  });

  final String currentRoute;
  final DeviceType device;
  final SectionNavigator onNavigate;
  final ValueChanged<String> onToast;
  final bool isTransitioning;
  final bool notificationsEnabled;
  final VoidCallback onToggleNotifications;

  bool get _rail => device == DeviceType.desktop;

  @override
  Widget build(BuildContext context) {
    final screen = Stack(
      key: ValueKey(currentRoute),
      children: [
        RouteGenerator.screenFor(
          currentRoute,
          device: device,
          onSectionChanged: onNavigate,
          onToast: onToast,
        ),
        if (isTransitioning)
          const Positioned.fill(child: RouteTransitionOverlay()),
      ],
    );

    final topBar = TopBar(
      subtitle: RouteGenerator.subtitleFor(currentRoute),
      notificationsEnabled: notificationsEnabled,
      onToggleNotifications: onToggleNotifications,
      onNotifyPressed: () {
        if (notificationsEnabled) {
          onToast(
            'เปิดศูนย์แจ้งเตือน: รถสาย 1, class ENG-301 และกิจกรรมที่ save ไว้',
          );
        } else {
          onToast('การแจ้งเตือนปิดอยู่ · กดค้างที่ไอคอนเพื่อเปิด');
        }
      },
    );

    if (_rail) {
      return ColoredBox(
        color: AppColors.paper,
        child: Column(
          children: [
            topBar,
            Expanded(
              child: Row(
                children: [
                  BottomNav(
                    currentRoute: currentRoute,
                    rail: true,
                    onSelected: onNavigate,
                  ),
                  Expanded(child: screen),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return ColoredBox(
      color: AppColors.paper,
      child: Column(
        children: [
          topBar,
          Expanded(child: screen),
          BottomNav(
            currentRoute: currentRoute,
            rail: false,
            onSelected: onNavigate,
          ),
        ],
      ),
    );
  }
}
