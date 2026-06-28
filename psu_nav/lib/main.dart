import 'package:flutter/material.dart';

void main() {
  runApp(const PsuNavigatorApp());
}

class MyApp extends PsuNavigatorApp {
  const MyApp({super.key});
}

enum AppSection { map, indoor, shuttle, events, community, profile }

class AppColors {
  static const ink = Color(0xFF101A2C);
  static const muted = Color(0xFF667189);
  static const paper = Color(0xFFF5F8FC);
  static const line = Color(0xFFDBE4F2);
  static const campus = Color(0xFF004A98);
  static const campus2 = Color(0xFF1569C7);
  static const lake = Color(0xFFC6E5F7);
  static const road = Color(0xFFD6DFEC);
  static const sun = Color(0xFFF3B443);
  static const alert = Color(0xFFC94D3F);
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
          _IconButton(
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

class _MapScreen extends StatelessWidget {
  const _MapScreen({
    required this.desktop,
    required this.onSectionSelected,
    required this.onToast,
  });

  final bool desktop;
  final ValueChanged<AppSection> onSectionSelected;
  final ValueChanged<String> onToast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SearchRow(
          value: 'ENG-301 อาคารวิศวกรรมศาสตร์ 1',
          trailing: Icons.tune,
          onTrailing: () =>
              onToast('ค้นหาแล้ว: ENG-301 อยู่ชั้น 3 อาคารวิศวกรรมศาสตร์ 1'),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              desktop ? 22 : 16,
              0,
              desktop ? 22 : 16,
              12,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  const Positioned.fill(child: _CampusMapBackground()),
                  const Positioned(
                    top: 14,
                    left: 14,
                    child: _MapLabel(
                      title: 'Outdoor map mode',
                      subtitle: 'Google Maps + PSU overlay',
                    ),
                  ),
                  _MapPin(
                    left: .48,
                    top: .46,
                    icon: Icons.apartment,
                    label: 'วิศวกรรม 1',
                    color: AppColors.campus,
                    onTap: () {
                      onSectionSelected(AppSection.indoor);
                      onToast(
                        'เข้าสู่ Indoor View: อาคารวิศวกรรมศาสตร์ 1 ชั้น 3',
                      );
                    },
                  ),
                  _MapPin(
                    left: .73,
                    top: .64,
                    icon: Icons.restaurant_outlined,
                    label: 'โรงอาหารกลาง',
                    color: AppColors.sun,
                    onTap: () => onSectionSelected(AppSection.community),
                  ),
                  _MapPin(
                    left: .29,
                    top: .70,
                    icon: Icons.directions_bus_outlined,
                    label: 'ป้ายรถ A',
                    color: AppColors.campus2,
                    onTap: () => onSectionSelected(AppSection.shuttle),
                  ),
                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: 12,
                    child: _PlaceCard(
                      onIndoor: () => onSectionSelected(AppSection.indoor),
                      onCommunity: () =>
                          onSectionSelected(AppSection.community),
                      onToast: onToast,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CampusMapBackground extends StatelessWidget {
  const _CampusMapBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CampusMapPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _CampusMapPainter extends CustomPainter {
  const _CampusMapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(const Color(0xFFEAF1F8), BlendMode.src);
    final grid = Paint()
      ..color = Colors.white.withValues(alpha: .44)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 44) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y < size.height; y += 44) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final road = Paint()
      ..color = AppColors.road
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * .08, size.height * .88),
      Offset(size.width * .85, size.height * .18),
      road,
    );
    canvas.drawLine(
      Offset(size.width * .12, size.height * .28),
      Offset(size.width * .95, size.height * .78),
      road,
    );

    final lake = Paint()..color = AppColors.lake;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * .76, size.height * .18),
        width: size.width * .28,
        height: size.height * .18,
      ),
      lake,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MapLabel extends StatelessWidget {
  const _MapLabel({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .86),
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
          ),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

class _MapPin extends StatelessWidget {
  const _MapPin({
    required this.left,
    required this.top,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final double left;
  final double top;
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Positioned(
                left: constraints.maxWidth * left - 36,
                top: constraints.maxHeight * top - 34,
                child: GestureDetector(
                  onTap: onTap,
                  child: Column(
                    children: [
                      Transform.rotate(
                        angle: -0.785,
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(3),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: color.withValues(alpha: .30),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Transform.rotate(
                            angle: 0.785,
                            child: Icon(icon, color: Colors.white, size: 18),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: AppColors.line),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          label,
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PlaceCard extends StatelessWidget {
  const _PlaceCard({
    required this.onIndoor,
    required this.onCommunity,
    required this.onToast,
  });

  final VoidCallback onIndoor;
  final VoidCallback onCommunity;
  final ValueChanged<String> onToast;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _MiniIcon(Icons.apartment),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'อาคารวิศวกรรมศาสตร์ 1',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'ชั้น 3 · ห้อง ENG-301 · เดิน 7 นาทีจากตำแหน่งคุณ',
                      style: TextStyle(color: AppColors.muted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              _StatusChip('เปิดอยู่'),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  'นำทาง',
                  AppColors.campus,
                  () => onToast('เริ่ม route ไปอาคารวิศวกรรมศาสตร์ 1'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionButton('เข้าอาคาร', AppColors.campus2, onIndoor),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionButton(
                  'รีวิว',
                  const Color(0xFFEDF4FF),
                  onCommunity,
                  foreground: AppColors.campus,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IndoorScreen extends StatelessWidget {
  const _IndoorScreen({
    required this.desktop,
    required this.onSectionSelected,
    required this.onToast,
  });

  final bool desktop;
  final ValueChanged<AppSection> onSectionSelected;
  final ValueChanged<String> onToast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SearchRow(
          value: 'ENG-301 ห้องบรรยายรวม',
          leading: Icons.arrow_back,
          onLeading: () => onSectionSelected(AppSection.map),
        ),
        _Tabs(
          labels: const ['ชั้น 1', 'ชั้น 2', 'ชั้น 3', 'ชั้น 4', 'ชั้น 5'],
          selected: 2,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              desktop ? 22 : 16,
              0,
              desktop ? 22 : 16,
              12,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.line),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: const [
                  _FloorPlanBase(),
                  _RoomBox(
                    label: 'ENG-301',
                    left: 34,
                    top: 34,
                    width: 84,
                    height: 50,
                  ),
                  _RoomBox(
                    label: 'ENG-302',
                    left: 132,
                    top: 34,
                    width: 112,
                    height: 50,
                    hot: true,
                  ),
                  _RoomBox(
                    label: 'Lab',
                    left: 258,
                    top: 34,
                    width: 72,
                    height: 50,
                  ),
                  _RoomBox(
                    label: 'Toilet',
                    left: 34,
                    top: 178,
                    width: 96,
                    height: 56,
                  ),
                  _RoomBox(
                    label: 'Lift',
                    left: 144,
                    top: 178,
                    width: 96,
                    height: 56,
                  ),
                  _RoomBox(
                    label: 'Stair',
                    left: 254,
                    top: 178,
                    width: 76,
                    height: 56,
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: AppColors.line)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ENG-302 · ห้องบรรยายรวม',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _SoftPill('120 ที่นั่ง'),
                  _SoftPill('Projector + AC'),
                  _SoftPill('08:00-17:00'),
                  _SoftPill('rating 4.6'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FloorPlanBase extends StatelessWidget {
  const _FloorPlanBase();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(child: CustomPaint(painter: _FloorPlanPainter()));
  }
}

class _FloorPlanPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFEDF3FB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18;
    final rect = Rect.fromLTWH(28, 88, size.width - 56, 70);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RoomBox extends StatelessWidget {
  const _RoomBox({
    required this.label,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    this.hot = false,
  });

  final String label;
  final double left;
  final double top;
  final double width;
  final double height;
  final bool hot;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: hot ? const Color(0xFFEAF2FF) : const Color(0xFFFBFDFF),
                border: Border.all(
                  color: hot ? AppColors.campus : const Color(0xFFCBD7E6),
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    color: hot ? AppColors.campus : AppColors.muted,
                    fontSize: 11,
                    fontWeight: hot ? FontWeight.w900 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          if (hot)
            Positioned(
              top: -6,
              right: -6,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.alert,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.alert.withValues(alpha: .14),
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ShuttleScreen extends StatelessWidget {
  const _ShuttleScreen({required this.desktop, required this.onToast});

  final bool desktop;
  final ValueChanged<String> onToast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Tabs(
          labels: const ['สาย 1', 'สาย 2', 'สาย 3', 'Saved stop'],
          selected: 0,
        ),
        Expanded(
          child: _ResponsiveList(
            desktop: desktop,
            children: [
              _InfoCard(
                icon: Icons.directions_bus_outlined,
                title: 'สาย 1 · คันที่ 3',
                subtitle:
                    'จากท่ารถ A ไปโรงอาหารกลาง · ข้อมูล cache ล่าสุด 07:42',
                trailing: const _RightPill('3 นาที'),
                child: const _Timeline(),
              ),
              _InfoCard(
                icon: Icons.notifications_outlined,
                title: 'แจ้งเตือนป้ายประจำ',
                subtitle:
                    'เตือนก่อนรถออก 5 นาที และยังดูตารางล่าสุดได้แม้ออฟไลน์',
                trailing: _SmallPrimaryButton(
                  'เปิด',
                  () => onToast(
                    'เปิด push notification สำหรับป้ายวิศวกรรมศาสตร์ 1 แล้ว',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EventsScreen extends StatelessWidget {
  const _EventsScreen({required this.desktop, required this.onToast});

  final bool desktop;
  final ValueChanged<String> onToast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Tabs(
          labels: const ['วันนี้', 'สัปดาห์นี้', 'Plan', 'Activity'],
          selected: 0,
        ),
        Expanded(
          child: _ResponsiveList(
            desktop: desktop,
            children: [
              const _InfoCard(
                icon: Icons.event_outlined,
                title: 'Hackathon: Smart Campus',
                subtitle:
                    'กิจกรรมจริง · ปักหมุดที่วิศวกรรม 1 · หมดเวลาโพสต์ 18:00',
                trailing: _RightPill('เข้าร่วม'),
              ),
              _InfoCard(
                icon: Icons.groups_outlined,
                title: 'หาเพื่อนไปกินข้าวเที่ยง',
                subtitle:
                    'Plan mode · รอคนสนใจ 4/6 · ถ้าหมดเวลาจะเก็บไว้ 2 ชม. แล้วลบ',
                trailing: _SmallPrimaryButton(
                  'สนใจ',
                  () => onToast('ส่งความสนใจเข้าร่วม plan แล้ว'),
                ),
              ),
              _InfoCard(
                icon: Icons.chat_bubble_outline,
                title: 'สุ่มหาเพื่อนแชทชั่วคราว',
                subtitle:
                    'จับคู่จากผู้ใช้ online ใน campus · แชทจะลบหลังออกครบ 5 นาที',
                trailing: _SmallPrimaryButton(
                  'สุ่ม',
                  () => onToast('กำลังสุ่มจับคู่กับผู้ใช้ online ใกล้คุณ'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


class _CommunityScreen extends StatefulWidget {
  const _CommunityScreen({required this.desktop, required this.onToast});

  final bool desktop;
  final ValueChanged<String> onToast;

  @override
  State<_CommunityScreen> createState() => _CommunityScreenState();
}

class CommentItem {
  const CommentItem({
    required this.initials,
    required this.name,
    required this.text,
    this.time = 'เมื่อสักครู่',
    this.likes = 0,
    this.replies = const [],
  });

  final String initials;
  final String name;
  final String text;
  final String time;
  final int likes;
  final List<CommentItem> replies;
}

class PlaceDiscussion {
  PlaceDiscussion({
    required this.icon,
    required this.name,
    required this.subtitle,
    required this.ratingLabel,
    required this.statusLabel,
    required this.comments,
  });

  final IconData icon;
  final String name;
  final String subtitle;
  final String ratingLabel;
  final String statusLabel;
  final List<CommentItem> comments;
}

class _CommunityScreenState extends State<_CommunityScreen> {
  final TextEditingController _controller = TextEditingController();
  int? _selectedPlaceIndex;
  late final List<PlaceDiscussion> _places = [
    PlaceDiscussion(
      icon: Icons.restaurant_outlined,
      name: 'โรงอาหารกลาง',
      subtitle: '4.2 ดาว · เปิดอยู่ · คนหนาแน่นปานกลางจาก user online',
      ratingLabel: '128 รีวิว',
      statusLabel: 'เปิดอยู่',
      comments: [
        const CommentItem(
          initials: 'นศ',
          name: 'นศ.ปี 1',
          text: 'ตอนเที่ยงแถวร้านข้าวมันไก่สั้นสุด มีโต๊ะว่างฝั่งซ้าย',
          time: '5 นาทีที่แล้ว',
          likes: 18,
          replies: [
            CommentItem(
              initials: 'จน',
              name: 'เจน',
              text: 'จริง วันนี้ฝั่งซ้ายโล่งกว่า',
              time: '2 นาทีที่แล้ว',
              likes: 3,
            ),
            CommentItem(
              initials: 'มข',
              name: 'มิ้น',
              text: 'ขอบคุณมาก เดี๋ยวแวะไปตรงนั้นเลย',
              time: 'เมื่อสักครู่',
              likes: 1,
            ),
          ],
        ),
      ],
    ),
    PlaceDiscussion(
      icon: Icons.local_library_outlined,
      name: 'ห้องสมุดกลาง',
      subtitle: '4.7 ดาว · เงียบ · ปลั๊กว่างชั้น 2',
      ratingLabel: '64 รีวิว',
      statusLabel: 'เปิดอยู่',
      comments: const [
        CommentItem(
          initials: 'อศ',
          name: 'ออย',
          text: 'ชั้น 2 ฝั่งหน้าต่างเงียบมาก เหมาะกับอ่านหนังสือยาวๆ',
          time: '12 นาทีที่แล้ว',
          likes: 11,
        ),
      ],
    ),
    PlaceDiscussion(
      icon: Icons.wc_outlined,
      name: 'ห้องน้ำอาคาร 15',
      subtitle: '3.9 ดาว · ทำความสะอาดล่าสุด 09:20',
      ratingLabel: '22 รีวิว',
      statusLabel: 'ตรวจล่าสุด',
      comments: const [
        CommentItem(
          initials: 'ปท',
          name: 'ปาล์ม',
          text: 'ฝั่งขวาสะอาดกว่า และมีทิชชู่ครบ',
          time: '28 นาทีที่แล้ว',
          likes: 6,
        ),
      ],
    ),
  ];

  PlaceDiscussion? get _selectedPlace =>
      _selectedPlaceIndex == null ? null : _places[_selectedPlaceIndex!];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _post() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      widget.onToast('พิมพ์คอมเมนต์ก่อนส่ง');
      return;
    }
    final place = _selectedPlace;
    if (place == null) {
      widget.onToast('เลือกสถานที่ก่อนส่งคอมเมนต์');
      return;
    }
    setState(() {
      place.comments.insert(
        0,
        CommentItem(initials: 'คุณ', name: 'คุณ', text: text, likes: 0),
      );
      _controller.clear();
    });
    widget.onToast('คอมเมนต์ใหม่แสดงทันทีผ่าน live feed');
  }

  @override
  Widget build(BuildContext context) {
    final place = _selectedPlace;

    if (place == null) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: _Segmented(
                    labels: const ['สถานที่', 'ยอดนิยม', 'ล่าสุด'],
                    selected: 0,
                  ),
                ),
                const SizedBox(width: 10),
                _IconButton(
                  icon: Icons.star_border,
                  onTap: () =>
                      widget.onToast('ให้คะแนนสถานที่เมื่อเปิดหน้ารายละเอียด'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              itemCount: _places.length + 1,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                if (index == _places.length) {
                  return const _ModerationCard();
                }

                return _PlaceDiscussionCard(
                  place: _places[index],
                  onTap: () => setState(() => _selectedPlaceIndex = index),
                );
              },
            ),
          ),
        ],
      );
    }

    final children = [
      _InfoCard(
        icon: place.icon,
        title: place.name,
        subtitle: place.subtitle,
        trailing: _RightPill(place.ratingLabel),
      ),
      for (final comment in place.comments) _CommentCard(comment: comment),
      const _ModerationCard(),
    ];

    return Column(
      children: [
        _SearchRow(
          value: place.name,
          leading: Icons.arrow_back,
          onLeading: () => setState(() => _selectedPlaceIndex = null),
          trailing: Icons.star_border,
          onTrailing: () => widget.onToast('ให้คะแนนสถานที่นี้ 5 ดาว'),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: _Segmented(
                  labels: const ['ล่าสุด', 'ยอดนิยม', 'รูปภาพ'],
                  selected: 0,
                ),
              ),
              const SizedBox(width: 10),
              _StatusChip(place.statusLabel),
            ],
          ),
        ),
        Expanded(
          child: _ResponsiveList(desktop: widget.desktop, children: children),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: AppColors.line)),
          ),
          child: Row(
            children: [
              _IconButton(
                icon: Icons.image_outlined,
                onTap: () =>
                    widget.onToast('เลือกรูปได้สูงสุด 3 รูปต่อคอมเมนต์'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'แชร์ข้อมูลสถานที่นี้...',
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.line),
                    ),
                  ),
                  onSubmitted: (_) => _post(),
                ),
              ),
              const SizedBox(width: 8),
              _IconButton(icon: Icons.send_outlined, onTap: _post),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlaceDiscussionCard extends StatelessWidget {
  const _PlaceDiscussionCard({required this.place, required this.onTap});

  final PlaceDiscussion place;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final previewComments = place.comments.take(2).toList();
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: _Panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _MiniIcon(place.icon),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        place.subtitle,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 12,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _RightPill(place.ratingLabel),
                    const SizedBox(height: 8),
                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.muted,
                      size: 18,
                    ),
                  ],
                ),
              ],
            ),
            if (previewComments.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                'รีวิวล่าสุด',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              for (final comment in previewComments)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Avatar(comment.initials),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F8FC),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${comment.name} · ${comment.time}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                comment.text,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.muted,
                                  fontSize: 11,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProfileScreen extends StatelessWidget {
  const _ProfileScreen({required this.desktop, required this.onToast});

  final bool desktop;
  final ValueChanged<String> onToast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _ResponsiveList(
            desktop: desktop,
            children: [
              _ProfileHeader(onToast: onToast),
              _InfoCard(
                icon: Icons.notifications_outlined,
                title: 'ตารางเรียนและกิจกรรม',
                subtitle:
                    'ENG-302 เริ่ม 09:00 · เตือนในแอปและอีเมลก่อน 15 นาที',
                trailing: _IconButton(
                  icon: Icons.settings_outlined,
                  onTap: () =>
                      onToast('บันทึก notification preference แล้ว'),
                ),
              ),
              const _InfoCard(
                icon: Icons.cloud_done_outlined,
                title: 'Offline cache',
                subtitle:
                    'ตารางรถ, floor plan, place summary และรีวิวล่าสุดถูก cache ในเครื่อง',
                trailing: _RightPill('ready'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.onToast});

  final ValueChanged<String> onToast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.campus,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Avatar + Info row
          Row(
            children: [
              // Avatar
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF1569C7),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'ธน',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Name + student info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ธนพล สันพิทักษ์',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '6510110xxx · คณะวิศวกรรมศาสตร์',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: .75),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'thanapon@email.psu.ac.th',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: .60),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Buttons row
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => onToast('เปิดหน้าแก้ไขโปรไฟล์'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'แก้ไขโปรไฟล์',
                      style: TextStyle(
                        color: AppColors.campus,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () => onToast('ออกจากระบบ PSU SSO'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: .30),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'ออกจากระบบ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class _SearchRow extends StatelessWidget {
  const _SearchRow({
    required this.value,
    this.leading,
    this.trailing,
    this.onLeading,
    this.onTrailing,
  });

  final String value;
  final IconData? leading;
  final IconData? trailing;
  final VoidCallback? onLeading;
  final VoidCallback? onTrailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (leading != null) ...[
            _IconButton(icon: leading!, onTap: onLeading),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Container(
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.line),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppColors.ink, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      value,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.ink),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 10),
            _IconButton(icon: trailing!, onTap: onTrailing),
          ],
        ],
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.labels, required this.selected});

  final List<String> labels;
  final int selected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final active = index == selected;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: active ? AppColors.campus : Colors.white,
              border: Border.all(
                color: active ? AppColors.campus : AppColors.line,
              ),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              labels[index],
              style: TextStyle(
                color: active ? Colors.white : AppColors.muted,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        },
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemCount: labels.length,
      ),
    );
  }
}

class _ResponsiveList extends StatelessWidget {
  const _ResponsiveList({required this.desktop, required this.children});

  final bool desktop;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (!desktop) {
      return ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        itemBuilder: (context, index) => children[index],
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemCount: children.length,
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(22, 0, 22, 12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.35,
      ),
      itemBuilder: (context, index) => children[index],
      itemCount: children.length,
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.child,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MiniIcon(icon),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[const SizedBox(width: 8), trailing!],
            ],
          ),
          if (child != null) ...[const SizedBox(height: 10), child!],
        ],
      ),
    );
  }
}

class _CommentCard extends StatelessWidget {
  const _CommentCard({required this.comment});

  final CommentItem comment;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Avatar(comment.initials),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${comment.name} · ${comment.time}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      comment.text,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      children: [
                        Text('ถูกใจ ${comment.likes}', style: _toolText),
                        const Text('ตอบกลับ', style: _toolText),
                        const Text('รายงาน', style: _toolText),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (comment.replies.isNotEmpty) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 44),
              child: Column(
                children: [
                  for (final reply in comment.replies)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Avatar(reply.initials),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF6F8FC),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${reply.name} · ${reply.time}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    reply.text,
                                    style: const TextStyle(
                                      color: AppColors.muted,
                                      fontSize: 11,
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Wrap(
                                    spacing: 12,
                                    children: [
                                      Text(
                                        'ถูกใจ ${reply.likes}',
                                        style: _toolText,
                                      ),
                                      const Text('ตอบกลับ', style: _toolText),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ModerationCard extends StatelessWidget {
  const _ModerationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F6),
        border: Border.all(color: AppColors.alert.withValues(alpha: .32)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Avatar('--'),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ระบบตรวจจับ',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  'คอมเมนต์หนึ่งถูกซ่อนชั่วคราว เพราะ dislike/report สูงผิดปกติ รอ admin ตรวจสอบ',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  children: [
                    Text('auto moderation', style: _toolText),
                    Text('WebSocket update', style: _toolText),
                  ],
                ),
              ],
            ),
          ),
          _RightPill('hidden', alert: true),
        ],
      ),
    );
  }
}

const _toolText = TextStyle(color: AppColors.muted, fontSize: 11);

class _Timeline extends StatelessWidget {
  const _Timeline();

  @override
  Widget build(BuildContext context) {
    const stops = [
      ('ท่ารถ A', 'ผ่านแล้ว'),
      ('วิศวกรรมศาสตร์ 1', '07:48'),
      ('โรงอาหารกลาง', '07:55'),
    ];
    return Column(
      children: [
        for (var i = 0; i < stops.length; i++)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.campus,
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (i != stops.length - 1)
                    Container(
                      width: 2,
                      height: 28,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      color: AppColors.line,
                    ),
                ],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  stops[i].$1,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                stops[i].$2,
                style: const TextStyle(color: AppColors.muted, fontSize: 11),
              ),
            ],
          ),
      ],
    );
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

class _Panel extends StatelessWidget {
  const _Panel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .94),
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}

class _MiniIcon extends StatelessWidget {
  const _MiniIcon(this.icon);

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: const Color(0xFFE9F2FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: AppColors.campus, size: 18),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.line),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.ink, size: 18),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton(
    this.label,
    this.background,
    this.onTap, {
    this.foreground = Colors.white,
  });

  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        backgroundColor: background,
        foregroundColor: foreground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 10),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
      ),
    );
  }
}

class _SmallPrimaryButton extends StatelessWidget {
  const _SmallPrimaryButton(this.label, this.onTap);

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.campus,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: Size.zero,
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
      ),
    );
  }
}

class _RightPill extends StatelessWidget {
  const _RightPill(this.label, {this.alert = false});

  final String label;
  final bool alert;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: alert ? const Color(0xFFFDECEA) : const Color(0xFFEEF5F8),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: alert ? AppColors.alert : AppColors.campus2,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF2FF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.campus,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _SoftPill extends StatelessWidget {
  const _SoftPill(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F5FB),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(color: AppColors.muted, fontSize: 11),
      ),
    );
  }
}

class _Segmented extends StatelessWidget {
  const _Segmented({required this.labels, required this.selected});

  final List<String> labels;
  final int selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 9),
                color: i == selected ? AppColors.campus : Colors.transparent,
                alignment: Alignment.center,
                child: Text(
                  labels[i],
                  style: TextStyle(
                    color: i == selected ? Colors.white : AppColors.muted,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar(this.initials);

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: const Color(0xFFE9F2FF),
        borderRadius: BorderRadius.circular(9),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(
          color: AppColors.campus,
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }
}
