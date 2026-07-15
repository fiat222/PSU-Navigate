import 'package:flutter/material.dart';

import '../../app/app_colors.dart';
import '../action_button.dart';
import '../mini_icon.dart';
import '../panel.dart';
import '../status_chip.dart';

class PlaceCard extends StatelessWidget {
  const PlaceCard({
    super.key,
    required this.onIndoor,
    required this.onCommunity,
    required this.onNavigate,
  });

  final VoidCallback onIndoor;
  final VoidCallback onCommunity;
  final VoidCallback onNavigate;

  @override
  Widget build(BuildContext context) {
    return Panel(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MiniIcon(Icons.apartment),
                SizedBox(width: 10),
                Expanded(
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
                  child: ActionButton('นำทาง', AppColors.campus, onNavigate),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ActionButton('เข้าอาคาร', AppColors.campus2, onIndoor),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ActionButton(
                    'รีวิว',
                    AppColors.softBlue,
                    onCommunity,
                    foreground: AppColors.campus,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
