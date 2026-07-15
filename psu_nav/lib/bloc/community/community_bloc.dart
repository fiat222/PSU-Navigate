import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/place_repository.dart';
import '../../models/place_discussion.dart';
import 'community_event.dart';
import 'community_state.dart';

class CommunityBloc extends Bloc<CommunityEvent, CommunityState> {
  CommunityBloc({required this.repo})
    : super(const CommunityState(loading: true)) {
    on<LoadPlaces>(_onLoad);
    on<ChangeSegment>((e, emit) {
      emit(state.copyWith(segmentIndex: e.index));
      _emitFiltered(emit);
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
      emit(state.copyWith(clearSelected: true));
    });
    on<PostComment>(_onPost);
    on<ToastShown>((e, emit) {
      emit(state.copyWith(toastMessage: null));
    });
  }

  final PlaceRepository repo;

  Future<void> _onLoad(LoadPlaces e, Emitter<CommunityState> emit) async {
    emit(state.copyWith(loading: true, errorMessage: null));
    try {
      final all = await repo.fetchPlaces();
      emit(state.copyWith(loading: false, allPlaces: all));
      _emitFiltered(emit);
    } catch (err) {
      emit(state.copyWith(loading: false, errorMessage: err.toString()));
    }
  }

  void _onSelectPlace(SelectPlace e, Emitter<CommunityState> emit) {
    if (e.index < 0 || e.index >= state.places.length) return;
    final place = state.places[e.index];
    emit(
      state.copyWith(
        selectedIndex: e.index,
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

    emit(state.copyWith(posting: true));
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
      emit(state.copyWith(posting: false, errorMessage: err.toString()));
    }
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
