import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/place_repository.dart';
import '../../models/comment_item.dart';
import '../../models/place_discussion.dart';
import 'community_event.dart';
import 'community_state.dart';

class CommunityBloc extends Bloc<CommunityEvent, CommunityState> {
  CommunityBloc({required this.repo}) : super(CommunityState(loading: true)) {
    on<LoadPlaces>(_onLoad);
    on<ChangeSegment>((e, emit) {
      emit(state.copyWith(segmentIndex: e.index));
      _emitFiltered(emit);
    });
    on<ChangeDetailSegment>((e, emit) {
      if (e.index < 0 || e.index > 2) return;
      emit(state.copyWith(detailSegmentIndex: e.index));
    });
    on<SearchPlaces>((e, emit) {
      emit(state.copyWith(query: e.query));
      _emitFiltered(emit);
    });
    on<ChangeCategoryFilter>((e, emit) {
      emit(
        state.copyWith(
          categoryFilter: e.category,
          clearCategory: e.category == null,
        ),
      );
      _emitFiltered(emit);
    });
    on<SelectPlace>(_onSelectPlace);
    on<DeselectPlace>((e, emit) {
      emit(state.copyWith(clearSelected: true, clearReplyTarget: true));
    });
    on<PostComment>(_onPost);
    on<RateSelectedPlace>(_onRateSelectedPlace);
    on<ToggleCommentLike>(_onToggleCommentLike);
    on<StartReply>(_onStartReply);
    on<CancelReply>((event, emit) {
      if (state.replyInProgress) return;
      emit(state.copyWith(clearReplyTarget: true));
    });
    on<SubmitReply>(_onSubmitReply);
    on<ReportComment>(_onReportComment);
    on<ToastShown>((e, emit) {
      emit(state.copyWith(clearToast: true));
    });
    on<ClearCommunityError>((e, emit) {
      emit(state.copyWith(clearError: true));
    });
  }

  final PlaceRepository repo;
  int _replySequence = 0;

  Future<void> _onLoad(LoadPlaces e, Emitter<CommunityState> emit) async {
    emit(state.copyWith(loading: true, clearError: true));
    try {
      final all = await repo.fetchPlaces();
      emit(state.copyWith(loading: false, allPlaces: all));
      _emitFiltered(emit);
    } catch (err) {
      emit(
        state.copyWith(loading: false, errorMessage: 'ไม่สามารถโหลดรีวิวได้'),
      );
    }
  }

  void _onSelectPlace(SelectPlace e, Emitter<CommunityState> emit) {
    final place = state.allPlaces.where((p) => p.id == e.placeId).firstOrNull;
    if (place == null) return;
    emit(
      state.copyWith(
        selectedPlaceId: place.id,
        clearReplyTarget: state.selectedPlaceId != place.id,
        toastMessage: 'เข้าสู่สถานที่: ${place.name}',
      ),
    );
  }

  Future<void> _onPost(PostComment e, Emitter<CommunityState> emit) async {
    final text = e.text.trim();
    if (text.isEmpty) {
      emit(state.copyWith(toastMessage: 'กรุณาพิมพ์ข้อความก่อนส่ง'));
      return;
    }
    if (state.posting) return;
    final selected = state.selectedPlace;
    if (selected == null) {
      emit(state.copyWith(toastMessage: 'กรุณาเลือกสถานที่ก่อนคอมเมนต์'));
      return;
    }

    emit(state.copyWith(posting: true, clearError: true));
    try {
      final updated = await repo.postComment(placeId: selected.id, text: text);
      final newAll = state.allPlaces
          .map((p) => p.id == updated.id ? updated : p)
          .toList();
      emit(
        state.copyWith(
          allPlaces: newAll,
          posting: false,
          toastMessage: 'ส่งคอมเมนต์สำเร็จ',
        ),
      );
      _emitFiltered(emit);
    } catch (err) {
      emit(
        state.copyWith(
          posting: false,
          errorMessage: 'ส่งคอมเมนต์ไม่สำเร็จ กรุณาลองใหม่',
        ),
      );
    }
  }

  void _onRateSelectedPlace(
    RateSelectedPlace event,
    Emitter<CommunityState> emit,
  ) {
    final selected = state.selectedPlace;
    if (selected == null || event.rating < 1 || event.rating > 5) return;
    emit(
      state.copyWith(
        ratingsByPlace: {...state.ratingsByPlace, selected.id: event.rating},
        toastMessage: 'บันทึกคะแนน ${event.rating} ดาวสำหรับ session นี้',
      ),
    );
  }

  void _onToggleCommentLike(
    ToggleCommentLike event,
    Emitter<CommunityState> emit,
  ) {
    if (!_commentExists(event.commentId)) return;
    final liked = {...state.likedCommentIds};
    final isLiked = liked.remove(event.commentId);
    if (!isLiked) liked.add(event.commentId);
    emit(
      state.copyWith(
        likedCommentIds: liked,
        toastMessage: isLiked
            ? 'ยกเลิกถูกใจสำหรับ session นี้'
            : 'ถูกใจแล้วสำหรับ session นี้',
      ),
    );
  }

  void _onStartReply(StartReply event, Emitter<CommunityState> emit) {
    final selected = state.selectedPlace;
    if (selected == null || state.replyInProgress) return;
    if (!selected.comments.any((comment) => comment.id == event.commentId)) {
      return;
    }
    emit(state.copyWith(replyTargetId: event.commentId));
  }

  Future<void> _onSubmitReply(
    SubmitReply event,
    Emitter<CommunityState> emit,
  ) async {
    if (state.replyInProgress) return;
    final text = event.text.trim();
    final selected = state.selectedPlace;
    final targetId = state.replyTargetId;
    if (text.isEmpty || selected == null || targetId == null) {
      emit(
        state.copyWith(
          toastMessage: 'Prototype: เลือกความคิดเห็นและพิมพ์คำตอบก่อนส่ง',
        ),
      );
      return;
    }
    if (!selected.comments.any((comment) => comment.id == targetId)) return;

    emit(state.copyWith(replyInProgress: true));
    await Future<void>.delayed(const Duration(milliseconds: 250));

    final reply = CommentItem(
      id: 'session-reply-${++_replySequence}',
      initials: 'คุณ',
      name: 'ตัวคุณ',
      text: text,
    );
    final updatedPlace = selected.copyWith(
      comments: selected.comments
          .map(
            (comment) => comment.id == targetId
                ? comment.copyWith(replies: [...comment.replies, reply])
                : comment,
          )
          .toList(),
    );
    final allPlaces = state.allPlaces
        .map((place) => place.id == updatedPlace.id ? updatedPlace : place)
        .toList();
    emit(
      state.copyWith(
        allPlaces: allPlaces,
        replyInProgress: false,
        clearReplyTarget: true,
        toastMessage: 'Prototype: เพิ่มคำตอบใน session นี้แล้ว',
      ),
    );
    _emitFiltered(emit);
  }

  Future<void> _onReportComment(
    ReportComment event,
    Emitter<CommunityState> emit,
  ) async {
    if (state.reportInProgress ||
        state.reportedCommentIds.contains(event.commentId) ||
        !_commentExists(event.commentId)) {
      return;
    }
    emit(state.copyWith(reportInProgress: true));
    await Future<void>.delayed(const Duration(milliseconds: 250));
    emit(
      state.copyWith(
        reportInProgress: false,
        reportedCommentIds: {...state.reportedCommentIds, event.commentId},
        toastMessage: 'Prototype: บันทึกรายงานสำหรับ session นี้แล้ว',
      ),
    );
  }

  bool _commentExists(String commentId) {
    for (final place in state.allPlaces) {
      for (final comment in place.comments) {
        if (comment.id == commentId ||
            comment.replies.any((reply) => reply.id == commentId)) {
          return true;
        }
      }
    }
    return false;
  }

  void _emitFiltered(Emitter<CommunityState> emit) {
    emit(state.copyWith(places: _applyFilters(state.allPlaces)));
  }

  /// Frontend-only filter: text search + category chip + segment sort.
  List<PlaceDiscussion> _applyFilters(List<PlaceDiscussion> source) {
    Iterable<PlaceDiscussion> view = source;

    final q = state.query.trim().toLowerCase();
    if (q.isNotEmpty) {
      view = view.where((p) {
        return p.name.toLowerCase().contains(q) ||
            p.subtitle.toLowerCase().contains(q) ||
            p.tags.any((t) => t.toLowerCase().contains(q));
      });
    }

    final category = state.categoryFilter;
    if (category != null) {
      view = view.where((p) => p.category == category);
    }

    final list = view.toList();
    switch (state.segmentIndex) {
      case 1:
        list.sort((a, b) => b.popularityScore.compareTo(a.popularityScore));
        break;
      case 2:
        list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        break;
    }
    return list;
  }
}
