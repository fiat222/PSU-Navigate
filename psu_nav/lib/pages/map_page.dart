import 'package:flutter/material.dart' hide IconButton;

import '../app/app_colors.dart';
import '../app/app_theme.dart';
import '../routes/app_routes.dart';
import '../widgets/map/campus_map_background.dart';
import '../widgets/map/map_pin.dart';
import '../widgets/map/place_card.dart';
import '../widgets/search_row.dart';

class MapPage extends StatelessWidget {
  const MapPage({
    super.key,
    required this.device,
    required this.onSectionChanged,
    required this.onToast,
  });

  final DeviceType device;
  final SectionNavigator onSectionChanged;
  final ValueChanged<String> onToast;

  @override
  Widget build(BuildContext context) {
    final horizontal = device == DeviceType.phone ? 16.0 : 22.0;

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
            padding: EdgeInsets.fromLTRB(horizontal, 0, horizontal, 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  const Positioned.fill(child: CampusMapBackground()),
                  const Positioned(
                    top: 14,
                    left: 14,
                    child: MapLabel(
                      title: 'Outdoor map mode',
                      subtitle: 'Google Maps + PSU overlay',
                    ),
                  ),
                  MapPin(
                    leftPercent: .48,
                    topPercent: .46,
                    icon: Icons.apartment,
                    label: 'วิศวกรรม 1',
                    color: AppColors.campus,
                    onTap: () => onSectionChanged(
                      AppRoutes.indoor,
                      toast: 'เข้าสู่ Indoor View: อาคารวิศวกรรมศาสตร์ 1 ชั้น 3',
                    ),
                  ),
                  MapPin(
                    leftPercent: .73,
                    topPercent: .64,
                    icon: Icons.restaurant_outlined,
                    label: 'โรงอาหารกลาง',
                    color: AppColors.sun,
                    onTap: () => onSectionChanged(AppRoutes.community),
                  ),
                  MapPin(
                    leftPercent: .29,
                    topPercent: .70,
                    icon: Icons.directions_bus_outlined,
                    label: 'ป้ายรถ A',
                    color: AppColors.campus3,
                    onTap: () => onSectionChanged(AppRoutes.shuttle),
                  ),
                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: 12,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.45,
                      ),
                      child: PlaceCard(
                        onIndoor: () => onSectionChanged(AppRoutes.indoor),
                        onCommunity: () =>
                            onSectionChanged(AppRoutes.community),
                        onNavigate: () => onSectionChanged(
                          AppRoutes.indoor,
                          toast: 'เริ่ม route ไปอาคารวิศวกรรมศาสตร์ 1',
                        ),
                      ),
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
