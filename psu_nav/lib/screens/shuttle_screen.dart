part of '../main.dart';

class _ShuttleScreen extends StatelessWidget {
  const _ShuttleScreen({required this.desktop, required this.onToast});

  final bool desktop;
  final ValueChanged<String> onToast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Tabs(
          labels: const ['สาย 1', 'สาย 2', 'สาย 3', 'Saved stop'],
          selected: 0,
        ),
        Expanded(
          child: ResponsiveList(
            desktop: desktop,
            children: [
              InfoCard(
                icon: Icons.directions_bus_outlined,
                title: 'สาย 1 · คันที่ 3',
                subtitle:
                    'จากท่ารถ A ไปโรงอาหารกลาง · ข้อมูล cache ล่าสุด 07:42',
                trailing: const RightPill('3 นาที'),
                child: const _Timeline(),
              ),
              InfoCard(
                icon: Icons.notifications_outlined,
                title: 'แจ้งเตือนป้ายประจำ',
                subtitle:
                    'เตือนก่อนรถออก 5 นาที และยังดูตารางล่าสุดได้แม้ออฟไลน์',
                trailing: SmallPrimaryButton(
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
