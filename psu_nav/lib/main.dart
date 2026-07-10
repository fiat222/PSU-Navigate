import 'package:flutter/material.dart' hide IconButton;

import 'app/app_colors.dart';
import 'routes/app_routes.dart';
import 'routes/route_generator.dart';
import 'widgets/icon_button.dart';

void main() {
  runApp(const PsuNavigatorApp());
}

class MyApp extends PsuNavigatorApp {
  const MyApp({super.key});
}

class PsuNavigatorApp extends StatelessWidget {
  const PsuNavigatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PSU Campus Navigator',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Noto Sans Thai',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.campus,
          primary: AppColors.campus,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: AppColors.paper,
      ),
      home: const NavigatorPrototypePage(),
    );
  }
}

class NavigatorPrototypePage extends StatefulWidget {
  const NavigatorPrototypePage({super.key});

  @override
  State<NavigatorPrototypePage> createState() => _NavigatorPrototypePageState();
}

class _NavigatorPrototypePageState extends State<NavigatorPrototypePage> {
  String _currentRoute = AppRoutes.map;

  void _navigateTo(String route) {
    setState(() => _currentRoute = route);
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF102344),
          duration: const Duration(milliseconds: 1800),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return _PrototypeShell(
              currentRoute: _currentRoute,
              desktop: constraints.maxWidth >= 900,
              onNavigate: _navigateTo,
              onToast: _toast,
            );
          },
        ),
      ),
    );
  }
}

class _PrototypeShell extends StatelessWidget {
  const _PrototypeShell({
    required this.currentRoute,
    required this.desktop,
    required this.onNavigate,
    required this.onToast,
  });

  final String currentRoute;
  final bool desktop;
  final ValueChanged<String> onNavigate;
  final ValueChanged<String> onToast;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      children: [
        _TopBar(currentRoute: currentRoute, onToast: onToast),
        Expanded(
          child: RouteGenerator.screenFor(
            currentRoute,
            desktop: desktop,
            onSectionChanged: onNavigate,
            onToast: onToast,
          ),
        ),
      ],
    );

    return ColoredBox(
      color: AppColors.paper,
      child: desktop
          ? Column(
              children: [
                _TopBar(currentRoute: currentRoute, onToast: onToast),
                Expanded(
                  child: Row(
                    children: [
                      _BottomNav(
                        currentRoute: currentRoute,
                        desktop: true,
                        onSelected: onNavigate,
                      ),
                      Expanded(
                        child: RouteGenerator.screenFor(
                          currentRoute,
                          desktop: true,
                          onSectionChanged: onNavigate,
                          onToast: onToast,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Column(
              children: [
                Expanded(child: content),
                _BottomNav(
                  currentRoute: currentRoute,
                  desktop: false,
                  onSelected: onNavigate,
                ),
              ],
            ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.currentRoute, required this.onToast});

  final String currentRoute;
  final ValueChanged<String> onToast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
      decoration: const BoxDecoration(
        color: Color(0xEEF5F8FC),
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                colors: [AppColors.campus, Color(0xFF05285A)],
              ),
            ),
            child: const Center(
              child: Text(
                'PSU',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Campus Navigator',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                ),
                Text(
                  RouteGenerator.subtitleFor(currentRoute),
                  style: const TextStyle(color: AppColors.muted, fontSize: 11),
                ),
              ],
            ),
          ),

          const _LiveDot(),
          const SizedBox(width: 8),
          IconButton(
            icon: Icons.notifications_outlined,
            onTap: () => onToast(
              'เปิดศูนย์แจ้งเตือน: รถสาย 1, class ENG-301 และกิจกรรมที่ save ไว้',
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.currentRoute,
    required this.desktop,
    required this.onSelected,
  });

  final String currentRoute;
  final bool desktop;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final items = [
      (AppRoutes.map, Icons.map_outlined, 'แผนที่'),
      (AppRoutes.shuttle, Icons.directions_bus_outlined, 'รถ'),
      (AppRoutes.events, Icons.event_outlined, 'กิจกรรม'),
      (AppRoutes.community, Icons.forum_outlined, 'ชุมชน'),
      (AppRoutes.profile, Icons.person_outline, 'ฉัน'),
    ];

    return Container(
      width: desktop ? 92 : null,
      padding: EdgeInsets.fromLTRB(desktop ? 10 : 8, 8, desktop ? 10 : 8, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: desktop
            ? const Border(right: BorderSide(color: AppColors.line))
            : const Border(top: BorderSide(color: AppColors.line)),
      ),
      child: desktop
          ? Column(
              children: items
                  .map(
                    (item) => _NavItem(
                      item: item,
                      active: item.$1 == currentRoute,
                      onTap: onSelected,
                      desktop: true,
                    ),
                  )
                  .toList(),
            )
          : Row(
              children: items
                  .map(
                    (item) => Expanded(
                      child: _NavItem(
                        item: item,
                        active: item.$1 == currentRoute,
                        onTap: onSelected,
                        desktop: false,
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.item,
    required this.active,
    required this.onTap,
    required this.desktop,
  });

  final (String, IconData, String) item;
  final bool active;
  final ValueChanged<String> onTap;
  final bool desktop;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: desktop ? 6 : 0),
      child: InkWell(
        onTap: () => onTap(item.$1),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: desktop ? 68 : 52,
          decoration: BoxDecoration(
            color: active ? const Color(0xFFE9F2FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                item.$2,
                color: active ? AppColors.campus : AppColors.muted,
                size: 20,
              ),
              const SizedBox(height: 2),
              Text(
                item.$3,
                style: TextStyle(
                  color: active ? AppColors.campus : AppColors.muted,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LiveDot extends StatelessWidget {
  const _LiveDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: Color(0xFF2BBE6A),
        shape: BoxShape.circle,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Color(0xFF2BBE6A), blurRadius: 4, spreadRadius: 1),
          ],
        ),
      ),
    );
  }
}
