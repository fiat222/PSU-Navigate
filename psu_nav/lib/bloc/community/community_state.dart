import 'package:equatable/equatable.dart';

import '../../models/place_discussion.dart';

class CommunityState extends Equatable {
  const CommunityState({
    this.allPlaces = const [],
    this.places = const [],
    this.selectedPlaceId,
    this.toastMessage,
    this.segmentIndex = 0,
    this.detailSegmentIndex = 0,
    this.query = '',
    this.categoryFilter,
    this.loading = false,
    this.posting = false,
    this.refreshing = false,
    this.errorMessage,
  });

  final List<PlaceDiscussion> allPlaces;
  final List<PlaceDiscussion> places;
  final String? selectedPlaceId;
  final String? toastMessage;
  final int segmentIndex;
  final int detailSegmentIndex;
  final String query;
  final PlaceCategory? categoryFilter;
  final bool loading;
  final bool posting;
  final bool refreshing;
  final String? errorMessage;

  PlaceDiscussion? get selectedPlace {
    final id = selectedPlaceId;
    if (id == null) return null;
    for (final place in allPlaces) {
      if (place.id == id) return place;
    }
    return null;
  }

  bool get isEmptyAfterLoad => !loading && allPlaces.isEmpty;

  CommunityState copyWith({
    List<PlaceDiscussion>? allPlaces,
    List<PlaceDiscussion>? places,
    String? selectedPlaceId,
    String? toastMessage,
    int? segmentIndex,
    int? detailSegmentIndex,
    String? query,
    PlaceCategory? categoryFilter,
    bool clearCategory = false,
    bool? loading,
    bool? posting,
    bool? refreshing,
    String? errorMessage,
    bool clearSelected = false,
    bool clearError = false,
    bool clearToast = false,
  }) {
    return CommunityState(
      allPlaces: allPlaces ?? this.allPlaces,
      places: places ?? this.places,
      selectedPlaceId: clearSelected
          ? null
          : (selectedPlaceId ?? this.selectedPlaceId),
      toastMessage: clearToast
          ? null
          : (toastMessage ?? this.toastMessage),
      segmentIndex: segmentIndex ?? this.segmentIndex,
      detailSegmentIndex: detailSegmentIndex ?? this.detailSegmentIndex,
      query: query ?? this.query,
      categoryFilter: clearCategory
          ? null
          : (categoryFilter ?? this.categoryFilter),
      loading: loading ?? this.loading,
      posting: posting ?? this.posting,
      refreshing: refreshing ?? this.refreshing,
      errorMessage: clearError
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    allPlaces,
    places,
    selectedPlaceId,
    toastMessage,
    segmentIndex,
    detailSegmentIndex,
    query,
    categoryFilter,
    loading,
    posting,
    refreshing,
    errorMessage,
  ];
}
