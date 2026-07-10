import 'package:flutter/material.dart';

import '../widgets/info_card.dart';
import '../widgets/responsive_list.dart';
import '../widgets/right_pill.dart';
import '../widgets/small_primary_button.dart';
import '../widgets/tabs.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key, required this.desktop, required this.onToast});

  final bool desktop;
  final ValueChanged<String> onToast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Tabs(
          labels: const ['วันนี้', 'สัปดาห์นี้', 'Plan', 'Activity'],
          selected: 0,
        ),
        Expanded(
          child: ResponsiveList(
            desktop: desktop,
            children: [
              const InfoCard(
                icon: Icons.event_outlined,
                title: 'Hackathon: Smart Campus',
                subtitle:
                    'กิจกรรมจริง · ปักหมุดที่วิศวกรรม 1 · หมดเวลาโพสต์ 18:00',
                trailing: RightPill('เข้าร่วม'),
              ),
              InfoCard(
                icon: Icons.groups_outlined,
                title: 'หาเพื่อนไปกินข้าวเที่ยง',
                subtitle:
                    'Plan mode · รอคนสนใจ 4/6 · ถ้าหมดเวลาจะเก็บไว้ 2 ชม. แล้วลบ',
                trailing: SmallPrimaryButton(
                  'สนใจ',
                  () => onToast('ส่งความสนใจเข้าร่วม plan แล้ว'),
                ),
              ),
              InfoCard(
                icon: Icons.chat_bubble_outline,
                title: 'สุ่มหาเพื่อนแชทชั่วคราว',
                subtitle:
                    'จับคู่จากผู้ใช้ online ใน campus · แชทจะลบหลังออกครบ 5 นาที',
                trailing: SmallPrimaryButton(
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
