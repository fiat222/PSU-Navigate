part of '../main.dart';

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
        SearchRow(
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

    final myLocDot = Paint()..color = AppColors.campus2;
    canvas.drawCircle(Offset(size.width * .22, size.height * .52), 6, myLocDot);
    canvas.drawCircle(
      Offset(size.width * .22, size.height * .52),
      16,
      Paint()..color = AppColors.campus2.withValues(alpha: .22),
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
    return Panel(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MiniIcon(Icons.apartment),
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
              StatusChip('เปิดอยู่'),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ActionButton(
                  'นำทาง',
                  AppColors.campus,
                  () => onToast('เริ่ม route ไปอาคารวิศวกรรมศาสตร์ 1'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ActionButton('เข้าอาคาร', AppColors.campus2, onIndoor),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ActionButton(
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
