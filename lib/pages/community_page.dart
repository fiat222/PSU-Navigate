import 'package:flutter/material.dart' hide IconButton;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/app_theme.dart';
import '../bloc/community/community_bloc.dart';
import '../bloc/community/community_event.dart';
import '../bloc/community/community_state.dart';
import '../data/repositories/place_repository.dart';
import '../models/comment_item.dart';
import '../models/place_discussion.dart';
import '../widgets/common/error_state.dart';
import '../widgets/common/loading_indicator.dart';
import '../widgets/common/responsive_list.dart';
import '../widgets/common/skeleton.dart';
import '../widgets/community/category_chips.dart';
import '../widgets/community/comment_card.dart';
import '../widgets/community/community_composer.dart';
import '../widgets/community/community_detail_toolbar.dart';
import '../widgets/community/place_discussion_card.dart';
import '../widgets/community/place_search_field.dart';
import '../widgets/community/rating_dialog.dart';
import '../widgets/icon_button.dart';
import '../widgets/segmented.dart';
import '../widgets/status_chip.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key, required this.device, required this.onToast});

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
          (curr.toastMessage != null &&
              curr.toastMessage != prev.toastMessage) ||
          (curr.errorMessage != null &&
              curr.errorMessage != prev.errorMessage &&
              curr.allPlaces.isNotEmpty),
      listener: (context, state) {
        if (state.toastMessage != null) {
          if (state.toastMessage == 'ส่งคอมเมนต์สำเร็จ' ||
              state.toastMessage == 'Prototype: เพิ่มคำตอบใน session นี้แล้ว') {
            _controller.clear();
          }
          widget.onToast(state.toastMessage!);
          context.read<CommunityBloc>().add(const ToastShown());
        }
        if (state.errorMessage != null && state.allPlaces.isNotEmpty) {
          widget.onToast(state.errorMessage!);
          context.read<CommunityBloc>().add(const ClearCommunityError());
        }
      },
      child: BlocBuilder<CommunityBloc, CommunityState>(
        builder: (context, state) {
          if (state.loading) {
            return const FullScreenLoading(label: 'กำลังโหลดรีวิวล่าสุด...');
          }

          if (state.errorMessage != null && state.allPlaces.isEmpty) {
            return ErrorState(
              message: state.errorMessage!,
              onRetry: () =>
                  context.read<CommunityBloc>().add(const LoadPlaces()),
            );
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
              device: widget.device,
              controller: _controller,
              onToast: widget.onToast,
            );
          }

          return _PlaceDetailView(
            place: place,
            state: state,
            device: widget.device,
            controller: _controller,
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
    required this.device,
    required this.controller,
    required this.onToast,
  });

  final CommunityState state;
  final DeviceType device;
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
              device: device,
              children: [
                for (var i = 0; i < state.places.length; i++)
                  PlaceDiscussionCard(
                    place: state.places[i],
                    onTap: () => context.read<CommunityBloc>().add(
                      SelectPlace(state.places[i].id),
                    ),
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
    required this.state,
    required this.device,
    required this.controller,
    required this.onToast,
  });

  final PlaceDiscussion place;
  final CommunityState state;
  final DeviceType device;
  final TextEditingController controller;
  final ValueChanged<String> onToast;

  void _post(BuildContext context) {
    final bloc = context.read<CommunityBloc>();
    if (state.replyTargetId == null) {
      bloc.add(PostComment(controller.text));
    } else {
      bloc.add(SubmitReply(controller.text));
    }
  }

  Future<void> _rate(BuildContext context) async {
    final rating = await showDialog<int>(
      context: context,
      builder: (context) => const RatingDialog(),
    );
    if (rating != null && context.mounted) {
      context.read<CommunityBloc>().add(RateSelectedPlace(rating));
    }
  }

  Future<void> _report(BuildContext context, String commentId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ยืนยันการรายงาน'),
        content: const Text('Prototype: รายงานนี้มีผลเฉพาะ session นี้'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('ยืนยันรายงาน'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<CommunityBloc>().add(ReportComment(commentId));
    }
  }

  String? get _replyTargetName {
    final targetId = state.replyTargetId;
    if (targetId == null) return null;
    for (final comment in place.comments) {
      if (comment.id == targetId) return comment.name;
    }
    return null;
  }

  CommentCard _commentCard(
    BuildContext context,
    CommentItem comment, {
    bool nested = false,
  }) {
    return CommentCard(
      comment: comment,
      nested: nested,
      isLiked: state.likedCommentIds.contains(comment.id),
      isReported: state.reportedCommentIds.contains(comment.id),
      onLike: () =>
          context.read<CommunityBloc>().add(ToggleCommentLike(comment.id)),
      onReply: nested
          ? null
          : () => context.read<CommunityBloc>().add(StartReply(comment.id)),
      onReport: state.reportInProgress
          ? null
          : () => _report(context, comment.id),
      replies: nested
          ? const []
          : [
              for (final reply in comment.replies)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _commentCard(context, reply, nested: true),
                ),
            ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final composer = CommunityComposer(
      controller: controller,
      posting: state.posting,
      replying: state.replyInProgress,
      replyTargetName: _replyTargetName,
      onCancelReply: () =>
          context.read<CommunityBloc>().add(const CancelReply()),
      onSubmit: () => _post(context),
      onImage: () => onToast('Prototype: การแนบรูปยังไม่พร้อมใช้งาน'),
    );
    return Column(
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CommunityDetailToolbar(
                  placeName: place.name,
                  sessionRating: state.ratingsByPlace[place.id],
                  onBack: () =>
                      context.read<CommunityBloc>().add(const DeselectPlace()),
                  onRate: () => _rate(context),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Segmented(
                          labels: const ['ล่าสุด', 'ยอดนิยม', 'รูปภาพ'],
                          selected: state.detailSegmentIndex,
                          onChanged: (index) => context
                              .read<CommunityBloc>()
                              .add(ChangeDetailSegment(index)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      StatusChip(place.statusLabel),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ResponsiveList(
            device: device,
            children: [
              PlaceHeader(place: place),
              for (final comment in place.comments)
                _commentCard(context, comment),
              const ModerationCard(),
            ],
          ),
        ),
        composer,
      ],
    );
  }
}
