import 'package:flutter/material.dart';

import '../app/app_colors.dart';
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
    required bool desktop,
    required void Function(String route) onSectionChanged,
    required ValueChanged<String> onToast,
  }) {
    switch (route) {
      case AppRoutes.map:
        return MapScreen(
          desktop: desktop,
          onSectionChanged: onSectionChanged,
          onToast: onToast,
        );
      case AppRoutes.indoor:
        return IndoorScreen(
          desktop: desktop,
          onSectionChanged: onSectionChanged,
          onToast: onToast,
        );
      case AppRoutes.shuttle:
        return ShuttleScreen(desktop: desktop, onToast: onToast);
      case AppRoutes.events:
        return EventsScreen(desktop: desktop, onToast: onToast);
      case AppRoutes.community:
        return CommunityScreen(desktop: desktop, onToast: onToast);
      case AppRoutes.profile:
        return ProfileScreen(desktop: desktop, onToast: onToast);
      default:
        return _UnknownScreen(route: route);
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

class _UnknownScreen extends StatelessWidget {
  const _UnknownScreen({required this.route});

  final String route;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.alert),
          const SizedBox(height: 16),
          Text(
            'Route not found',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
