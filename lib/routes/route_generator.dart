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
    String? indoorRoomCode,
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
          initialRoomCode: indoorRoomCode,
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
        return 'Hat Yai campus · Prototype map';
      case AppRoutes.indoor:
        return 'Indoor floor plan · Engineering 1';
      case AppRoutes.shuttle:
        return 'ตารางรถตัวอย่าง · session นี้';
      case AppRoutes.events:
        return 'Events and friend plans · mock data';
      case AppRoutes.community:
        return 'Place reviews · mock feed';
      case AppRoutes.profile:
        return 'บัญชีตัวอย่าง · session settings';
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
