import 'package:flutter/material.dart' hide IconButton;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/app_colors.dart';
import '../app/app_theme.dart';
import '../bloc/community/community_bloc.dart';
import '../bloc/community/community_event.dart';
import '../bloc/community/community_state.dart';
import '../data/repositories/place_repository.dart';
import '../models/place_discussion.dart';
import '../widgets/common/loading_indicator.dart';
import '../widgets/common/responsive_list.dart';
import '../widgets/common/skeleton.dart';
import '../widgets/community/category_chips.dart';
import '../widgets/community/place_discussion_card.dart';
import '../widgets/community/place_search_field.dart';
import '../widgets/icon_button.dart';
import '../widgets/search_row.dart';
import '../widgets/segmented.dart';
import '../widgets/status_chip.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({
    super.key,
    required this.device,
    required this.onToast,
  });

  final DeviceType device;
  final ValueChanged<String> onToast;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) =>
          CommunityBloc(repo: ctx.read<PlaceRepository>())
            ..add(const LoadPlaces()),
      child: _CommunityBody(device: device, onToast: onToast),
    );
  }
}

class _CommunityBody extends StatefulWidget {
  const _CommunityBody({required this.device, required this.onToast});

  final DeviceType device;
  final ValueChanged<String> onToast;

  @override
  State<_CommunityBody> createState() => _CommunityBodyState();
}

class _CommunityBodyState extends State<_CommunityBody> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CommunityBloc, CommunityState>(
      listenWhen: (prev, curr) =>
          curr.toastMessage != null && curr.toastMessage != prev.toastMessage,
      listener: (context, state) {
        if (state.toastMessage != null) {
          widget.onToast(state.toastMessage!);
          context.read<CommunityBloc>().add(const ToastShown());
        }
      },
      child: BlocBuilder<CommunityBloc, CommunityState>(
        builder: (context, state) {
          if (state.loading) {
            return const FullScreenLoading(label: 'กำลังโหลดรีวิวล่าสุด...');
          }

          if (state.isEmptyAfterLoad) {
            return const EmptyState(
              icon: Icons.forum_outlined,
              title: 'ยังไม่มีรีวิวในขณะนี้',
              subtitle: 'ลองรีเฟรชหรือกลับมาใหม่ในอีกสักครู่',
            );
          }

          final place = state.selectedPlace;
          if (place == null) {
            return _PlaceListView(
              state: state,
              controller: _controller,
              onToast: widget.onToast,
            );
          }

          return _PlaceDetailView(
            place: place,
            device: widget.device,
            controller: _controller,
            posting: state.posting,
            onToast: widget.onToast,
          );
        },
      ),
    );
  }
}

class _PlaceListView extends StatelessWidget {
  const _PlaceListView({
    required this.state,
    required this.controller,
    required this.onToast,
  });

  final CommunityState state;
  final TextEditingController controller;
  final ValueChanged<String> onToast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: PlaceSearchField(
            value: state.query,
            onChanged: (q) =>
                context.read<CommunityBloc>().add(SearchPlaces(q)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: CategoryChips(
            selected: state.categoryFilter,
            onSelected: (c) =>
                context.read<CommunityBloc>().add(ChangeCategoryFilter(c)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: Segmented(
                  labels: const ['สถานที่', 'ยอดนิยม', 'ล่าสุด'],
                  selected: state.segmentIndex,
                  onChanged: (i) =>
                      context.read<CommunityBloc>().add(ChangeSegment(i)),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: Icons.star_border,
                onTap: () => onToast('ให้คะแนนสถานที่เมื่อเปิดหน้ารายละเอียด'),
              ),
            ],
          ),
        ),
        if (state.places.isEmpty)
          const Expanded(
            child: EmptyState(
              icon: Icons.search_off,
              title: 'ไม่พบสถานที่ที่ตรงกับ filter',
              subtitle: 'ลองเปลี่ยนคำค้นหรือเลือกหมวดอื่น',
            ),
          )
        else
          Expanded(
            child: ResponsiveList(
              device: DeviceType.phone,
              children: [
                for (var i = 0; i < state.places.length; i++)
                  PlaceDiscussionCard(
                    place: state.places[i],
                    onTap: () =>
                        context.read<CommunityBloc>().add(SelectPlace(i)),
                  ),
                const ModerationCard(),
              ],
            ),
          ),
      ],
    );
  }
}

class _PlaceDetailView extends StatelessWidget {
  const _PlaceDetailView({
    required this.place,
    required this.device,
    required this.controller,
    required this.posting,
    required this.onToast,
  });

  final PlaceDiscussion place;
  final DeviceType device;
  final TextEditingController controller;
  final bool posting;
  final ValueChanged<String> onToast;

  void _post(BuildContext context) {
    context.read<CommunityBloc>().add(PostComment(controller.text));
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchRow(
          value: place.name,
          leading: Icons.arrow_back,
          onLeading: () =>
              context.read<CommunityBloc>().add(const DeselectPlace()),
          trailing: Icons.star_border,
          onTrailing: () => onToast('ให้คะแนนสถานที่นี้ 5 ดาว'),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Row(
            children: [
              const Expanded(
                child: Segmented(
                  labels: ['ล่าสุด', 'ยอดนิยม', 'รูปภาพ'],
                  selected: 0,
                ),
              ),
              const SizedBox(width: 10),
              StatusChip(place.statusLabel),
            ],
          ),
        ),
        Expanded(
          child: ResponsiveList(
            device: device,
            children: [
              PlaceHeader(place: place),
              for (final comment in place.comments)
                CommentCard(comment: comment),
              const ModerationCard(),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: AppColors.line)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (posting) const LinearProgressIndicator(minHeight: 2),
              if (posting) const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    icon: Icons.image_outlined,
                    onTap: () => onToast('เลือกรูปได้สูงสุด 3 รูปต่อคอมเมนต์'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      enabled: !posting,
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
                      onSubmitted: (_) => _post(context),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: posting ? Icons.hourglass_top : Icons.send_outlined,
                    onTap: posting ? null : () => _post(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
