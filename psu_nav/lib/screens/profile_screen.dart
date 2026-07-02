part of '../main.dart';

class _ProfileScreen extends StatelessWidget {
  const _ProfileScreen({required this.desktop, required this.onToast});

  final bool desktop;
  final ValueChanged<String> onToast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ResponsiveList(
            desktop: desktop,
            children: [
              _ProfileHeader(onToast: onToast),
              InfoCard(
                icon: Icons.notifications_outlined,
                title: 'ตารางเรียนและกิจกรรม',
                subtitle:
                    'ENG-302 เริ่ม 09:00 · เตือนในแอปและอีเมลก่อน 15 นาที',
                trailing: IconButton(
                  icon: Icons.settings_outlined,
                  onTap: () => onToast('บันทึก notification preference แล้ว'),
                ),
              ),
              const InfoCard(
                icon: Icons.cloud_done_outlined,
                title: 'Offline cache',
                subtitle:
                    'ตารางรถ, floor plan, place summary และรีวิวล่าสุดถูก cache ในเครื่อง',
                trailing: RightPill('ready'),
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
