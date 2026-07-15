import 'package:flutter/material.dart' hide IconButton;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/app_colors.dart';
import '../app/app_theme.dart';
import '../bloc/navigation/navigation_bloc.dart';
import '../routes/app_routes.dart';
import '../widgets/map/campus_map_background.dart';
import '../widgets/map/map_pin.dart';
import '../widgets/map/place_card.dart';
import '../widgets/search_row.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({
    super.key,
    required this.device,
    required this.onSectionChanged,
    required this.onToast,
  });

  final DeviceType device;
  final void Function(String route) onSectionChanged;
  final ValueChanged<String> onToast;

  Future<void> _handleNavigate(BuildContext context) async {
    final bloc = context.read<NavigationBloc>();
    final messenger = ScaffoldMessenger.of(context);
    bloc.add(const NavigateTo(AppRoutes.indoor));
    Future<void>.delayed(const Duration(milliseconds: 600), () {
      if (bloc.isClosed) return;
      messenger.showSnackBar(
        const SnackBar(
          content: Text('เริ่ม route ไปอาคารวิศวกรรมศาสตร์ 1'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

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
                    onTap: () {
                      onSectionChanged(AppRoutes.indoor);
                      onToast(
                        'เข้าสู่ Indoor View: อาคารวิศวกรรมศาสตร์ 1 ชั้น 3',
                      );
                    },
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
                    child: PlaceCard(
                      onIndoor: () => onSectionChanged(AppRoutes.indoor),
                      onCommunity: () => onSectionChanged(AppRoutes.community),
                      onNavigate: () => _handleNavigate(context),
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
