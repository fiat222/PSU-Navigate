import 'package:flutter/material.dart';

import '../../app/app_colors.dart';
import '../../app/app_theme.dart';
import '../../routes/app_routes.dart';

class NavItem {
  const NavItem(this.route, this.icon, this.label);
  final String route;
  final IconData icon;
  final String label;
}

const List<NavItem> kNavItems = [
  NavItem(AppRoutes.map, Icons.map_outlined, 'แผนที่'),
  NavItem(AppRoutes.shuttle, Icons.directions_bus_outlined, 'รถ'),
  NavItem(AppRoutes.events, Icons.event_outlined, 'กิจกรรม'),
  NavItem(AppRoutes.community, Icons.forum_outlined, 'ชุมชน'),
  NavItem(AppRoutes.profile, Icons.person_outline, 'ฉัน'),
];

class BottomNav extends StatelessWidget {
  const BottomNav({
    super.key,
    required this.currentRoute,
    required this.rail,
    required this.onSelected,
  });

  final String currentRoute;
  final bool rail;
  final SectionNavigator onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: rail ? AppLayout.navRailWidth : null,
      padding: EdgeInsets.fromLTRB(rail ? 10 : 8, 8, rail ? 10 : 8, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: rail
            ? const Border(right: BorderSide(color: AppColors.line))
            : const Border(top: BorderSide(color: AppColors.line)),
      ),
      child: rail ? _buildColumn() : _buildRow(),
    );
  }

  Widget _buildColumn() {
    return Column(
      children: [
        for (final item in kNavItems)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: _NavTile(
              item: item,
              active: item.route == currentRoute,
              onTap: onSelected,
              rail: true,
            ),
          ),
      ],
    );
  }

  Widget _buildRow() {
    return Row(
      children: [
        for (final item in kNavItems)
          Expanded(
            child: _NavTile(
              item: item,
              active: item.route == currentRoute,
              onTap: onSelected,
              rail: false,
            ),
          ),
      ],
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.item,
    required this.active,
    required this.onTap,
    required this.rail,
  });

  final NavItem item;
  final bool active;
  final SectionNavigator onTap;
  final bool rail;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(item.route),
      borderRadius: BorderRadius.circular(AppLayout.radiusMd),
      child: Container(
        height: rail
            ? AppLayout.navItemHeightDesktop
            : AppLayout.navItemHeightMobile,
        decoration: BoxDecoration(
          color: active ? AppColors.softBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(AppLayout.radiusMd),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              item.icon,
              color: active ? AppColors.campus : AppColors.muted,
              size: 20,
            ),
            const SizedBox(height: 2),
            Text(
              item.label,
              style: TextStyle(
                color: active ? AppColors.campus : AppColors.muted,
                fontSize: 10,
                fontWeight: active ? FontWeight.w800 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
