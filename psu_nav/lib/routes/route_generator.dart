import 'package:flutter/material.dart';

import '../app/app_colors.dart';
import '../app/app_theme.dart';
import '../pages/community_page.dart';
import '../pages/events_page.dart';
import '../pages/indoor_page.dart';
import '../pages/map_page.dart';
import '../pages/profile_page.dart';
import '../pages/shuttle_page.dart';
import 'app_routes.dart';

class RouteGenerator {
  static Widget pageFor(
    String route, {
    required DeviceType device,
    required SectionNavigator onSectionChanged,
    required ValueChanged<String> onToast,
  }) {
    switch (route) {
      case AppRoutes.map:
        return MapPage(
          device: device,
          onSectionChanged: onSectionChanged,
          onToast: onToast,
        );
      case AppRoutes.indoor:
        return IndoorPage(
          device: device,
          onSectionChanged: onSectionChanged,
          onToast: onToast,
        );
      case AppRoutes.shuttle:
        return ShuttlePage(device: device, onToast: onToast);
      case AppRoutes.events:
        return EventsPage(device: device, onToast: onToast);
      case AppRoutes.community:
        return CommunityPage(device: device, onToast: onToast);
      case AppRoutes.profile:
        return ProfilePage(device: device, onToast: onToast);
      default:
        return UnknownPage(route: route);
    }
  }

  static String subtitleFor(String route) {
    switch (route) {
      case AppRoutes.map:
        return 'Hat Yai campus · live';
      case AppRoutes.indoor:
        return 'Indoor floor plan · Engineering 1';
      case AppRoutes.shuttle:
        return 'Realtime shuttle · cached';
      case AppRoutes.events:
        return 'Events and friend plans';
      case AppRoutes.community:
        return 'Place reviews · live feed';
      case AppRoutes.profile:
        return 'PSU account · notifications';
      default:
        return 'Unknown route';
    }
  }
}

class UnknownPage extends StatelessWidget {
  const UnknownPage({super.key, required this.route});

  final String route;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.alert),
          const SizedBox(height: 16),
          const Text(
            'Route not found',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'The route "$route" does not exist.',
            style: const TextStyle(color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}
