import 'package:flutter/material.dart' hide IconButton;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/app_colors.dart';
import 'bloc/community/community_bloc.dart';
import 'bloc/community/community_event.dart';
import 'bloc/community/community_state.dart';
import 'models/comment_item.dart';
import 'models/place_discussion.dart';
import 'widgets/action_button.dart';
import 'widgets/avatar.dart';
import 'widgets/comment_bubble.dart';
import 'widgets/icon_button.dart';
import 'widgets/info_card.dart';
import 'widgets/mini_icon.dart';
import 'widgets/panel.dart';
import 'widgets/profile_action_button.dart';
import 'widgets/responsive_list.dart';
import 'widgets/right_pill.dart';
import 'widgets/search_row.dart';
import 'widgets/segmented.dart';
import 'widgets/small_primary_button.dart';
import 'widgets/soft_pill.dart';
import 'widgets/status_chip.dart';
import 'widgets/tabs.dart';

part 'screens/map_screen.dart';
part 'screens/indoor_screen.dart';
part 'screens/shuttle_screen.dart';
part 'screens/events_screen.dart';
part 'screens/community_screen.dart';
part 'screens/profile_screen.dart';

void main() {
  runApp(const PsuNavigatorApp());
}

class MyApp extends PsuNavigatorApp {
  const MyApp({super.key});
}

enum AppSection { map, indoor, shuttle, events, community, profile }

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
  AppSection _section = AppSection.map;

  void _show(AppSection section) {
    setState(() => _section = section);
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
              section: _section,
              desktop: constraints.maxWidth >= 900,
              onSectionSelected: _show,
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
    required this.section,
    required this.desktop,
    required this.onSectionSelected,
    required this.onToast,
  });

  final AppSection section;
  final bool desktop;
  final ValueChanged<AppSection> onSectionSelected;
  final ValueChanged<String> onToast;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      children: [
        _TopBar(section: section, onToast: onToast),
        Expanded(
          child: _ScreenHost(
            section: section,
            desktop: desktop,
            onSectionSelected: onSectionSelected,
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
                _TopBar(section: section, onToast: onToast),
                Expanded(
                  child: Row(
                    children: [
                      _BottomNav(
                        section: section,
                        desktop: true,
                        onSelected: onSectionSelected,
                      ),
                      Expanded(
                        child: _ScreenHost(
                          section: section,
                          desktop: true,
                          onSectionSelected: onSectionSelected,
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
                  section: section,
                  desktop: false,
                  onSelected: onSectionSelected,
                ),
              ],
            ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.section, required this.onToast});

  final AppSection section;
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
                  _sectionSubtitle(section),
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

String _sectionSubtitle(AppSection section) {
  return switch (section) {
    AppSection.map => 'Hat Yai campus · live',
    AppSection.indoor => 'Indoor floor plan · Engineering 1',
    AppSection.shuttle => 'Realtime shuttle · cached',
    AppSection.events => 'Events and friend plans',
    AppSection.community => 'Place reviews · live feed',
    AppSection.profile => 'PSU account · notifications',
  };
}

class _ScreenHost extends StatelessWidget {
  const _ScreenHost({
    required this.section,
    required this.desktop,
    required this.onSectionSelected,
    required this.onToast,
  });

  final AppSection section;
  final bool desktop;
  final ValueChanged<AppSection> onSectionSelected;
  final ValueChanged<String> onToast;

  @override
  Widget build(BuildContext context) {
    return switch (section) {
      AppSection.map => _MapScreen(
        desktop: desktop,
        onSectionSelected: onSectionSelected,
        onToast: onToast,
      ),
      AppSection.indoor => _IndoorScreen(
        desktop: desktop,
        onSectionSelected: onSectionSelected,
        onToast: onToast,
      ),
      AppSection.shuttle => _ShuttleScreen(desktop: desktop, onToast: onToast),
      AppSection.events => _EventsScreen(desktop: desktop, onToast: onToast),
      AppSection.community => _CommunityScreen(
        desktop: desktop,
        onToast: onToast,
      ),
      AppSection.profile => _ProfileScreen(desktop: desktop, onToast: onToast),
    };
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.section,
    required this.desktop,
    required this.onSelected,
  });

  final AppSection section;
  final bool desktop;
  final ValueChanged<AppSection> onSelected;

  @override
  Widget build(BuildContext context) {
    final items = [
      (AppSection.map, Icons.map_outlined, 'แผนที่'),
      (AppSection.shuttle, Icons.directions_bus_outlined, 'รถ'),
      (AppSection.events, Icons.event_outlined, 'กิจกรรม'),
      (AppSection.community, Icons.forum_outlined, 'ชุมชน'),
      (AppSection.profile, Icons.person_outline, 'ฉัน'),
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
                      active: item.$1 == section,
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
                        active: item.$1 == section,
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

  final (AppSection, IconData, String) item;
  final bool active;
  final ValueChanged<AppSection> onTap;
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
