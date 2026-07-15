import 'package:flutter/material.dart';

import '../app/app_colors.dart';
import '../app/app_theme.dart';
import '../screens/community_screen.dart';
import '../screens/events_screen.dart';
import '../screens/indoor_screen.dart';
import '../screens/map_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/shuttle_screen.dart';
import 'app_routes.dart';

class RouteGenerator {
  static Widget screenFor(
    String route, {
    required DeviceType device,
    required SectionNavigator onSectionChanged,
    required ValueChanged<String> onToast,
  }) {
    switch (route) {
      case AppRoutes.map:
        return MapScreen(
          device: device,
          onSectionChanged: onSectionChanged,
          onToast: onToast,
        );
      case AppRoutes.indoor:
        return IndoorScreen(
          device: device,
          onSectionChanged: onSectionChanged,
          onToast: onToast,
        );
      case AppRoutes.shuttle:
        return ShuttleScreen(device: device, onToast: onToast);
      case AppRoutes.events:
        return EventsScreen(device: device, onToast: onToast);
      case AppRoutes.community:
        return CommunityScreen(device: device, onToast: onToast);
      case AppRoutes.profile:
        return ProfileScreen(device: device, onToast: onToast);
      default:
        return UnknownScreen(route: route);
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

class UnknownScreen extends StatelessWidget {
  const UnknownScreen({super.key, required this.route});

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
