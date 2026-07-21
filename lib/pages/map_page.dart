import 'package:flutter/material.dart' hide IconButton;

import '../app/app_colors.dart';
import '../app/app_theme.dart';
import '../routes/app_routes.dart';
import '../widgets/map/campus_map_background.dart';
import '../widgets/map/map_pin.dart';
import '../widgets/map/place_card.dart';
import '../widgets/common/search_field.dart';
import '../widgets/icon_button.dart';

class MapPage extends StatefulWidget {
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
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  String _query = '';

  void _search([String? submitted]) {
    final query = (submitted ?? _query).trim().toLowerCase();
    final destination = switch (query) {
      'eng-301' || 'วิศวกรรม' => (AppRoutes.indoor, 'ENG-301'),
      'ป้ายรถ' || 'รถ' => (AppRoutes.shuttle, 'ป้ายรถ'),
      'โรงอาหาร' => (AppRoutes.community, 'โรงอาหาร'),
      _ => null,
    };
    if (destination == null) {
      widget.onToast('ไม่พบในข้อมูลตัวอย่าง');
      return;
    }
    widget.onSectionChanged(
      destination.$1,
      toast: 'Prototype: พบ ${destination.$2} ในข้อมูลตัวอย่าง',
      indoorRoomCode: destination.$1 == AppRoutes.indoor
          ? destination.$2
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final horizontal = widget.device == DeviceType.phone ? 16.0 : 22.0;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: SearchField(
                  key: const Key('map-search-field'),
                  value: _query,
                  hint: 'ค้นหาสถานที่หรือห้อง',
                  onChanged: (value) => _query = value,
                  onSubmitted: _search,
                ),
              ),
              const SizedBox(width: 10),
              IconButton(icon: Icons.tune, onTap: _search),
            ],
          ),
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
                      subtitle: 'แผนที่จำลอง + PSU prototype overlay',
                    ),
                  ),
                  MapPin(
                    leftPercent: .48,
                    topPercent: .46,
                    icon: Icons.apartment,
                    label: 'วิศวกรรม 1',
                    color: AppColors.campus,
                    onTap: () => widget.onSectionChanged(
                      AppRoutes.indoor,
                      toast:
                          'เข้าสู่ Indoor View: อาคารวิศวกรรมศาสตร์ 1 ชั้น 3',
                    ),
                  ),
                  MapPin(
                    leftPercent: .73,
                    topPercent: .64,
                    icon: Icons.restaurant_outlined,
                    label: 'โรงอาหารกลาง',
                    color: AppColors.sun,
                    onTap: () => widget.onSectionChanged(AppRoutes.community),
                  ),
                  MapPin(
                    leftPercent: .29,
                    topPercent: .70,
                    icon: Icons.directions_bus_outlined,
                    label: 'ป้ายรถ A',
                    color: AppColors.campus3,
                    onTap: () => widget.onSectionChanged(AppRoutes.shuttle),
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
                        onIndoor: () =>
                            widget.onSectionChanged(AppRoutes.indoor),
                        onCommunity: () =>
                            widget.onSectionChanged(AppRoutes.community),
                        onNavigate: () => widget.onSectionChanged(
                          AppRoutes.indoor,
                          toast:
                              'Prototype: เปิด Indoor View ของอาคารวิศวกรรมศาสตร์ 1 · ยังไม่ได้คำนวณเส้นทางจริง',
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
