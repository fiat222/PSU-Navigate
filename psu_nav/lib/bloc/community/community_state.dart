import 'package:equatable/equatable.dart';

import '../../models/place_discussion.dart';

class CommunityState extends Equatable {
  const CommunityState({
    this.allPlaces = const [],
    this.places = const [],
    this.selectedIndex,
    this.toastMessage,
    this.segmentIndex = 0,
    this.query = '',
    this.categoryFilter,
    this.loading = false,
    this.posting = false,
    this.refreshing = false,
    this.errorMessage,
  });

  final List<PlaceDiscussion> allPlaces;
  final List<PlaceDiscussion> places;
  final int? selectedIndex;
  final String? toastMessage;
  final int segmentIndex;
  final String query;
  final PlaceCategory? categoryFilter;
  final bool loading;
  final bool posting;
  final bool refreshing;
  final String? errorMessage;

  PlaceDiscussion? get selectedPlace {
    final i = selectedIndex;
    if (i == null || i < 0 || i >= places.length) return null;
    return places[i];
  }

  bool get isEmptyAfterLoad => !loading && allPlaces.isEmpty;

  CommunityState copyWith({
    List<PlaceDiscussion>? allPlaces,
    List<PlaceDiscussion>? places,
    int? selectedIndex,
    String? toastMessage,
    int? segmentIndex,
    String? query,
    PlaceCategory? categoryFilter,
    bool clearCategory = false,
    bool? loading,
    bool? posting,
    bool? refreshing,
    String? errorMessage,
    bool clearSelected = false,
  }) {
    return CommunityState(
      allPlaces: allPlaces ?? this.allPlaces,
      places: places ?? this.places,
      selectedIndex: clearSelected
          ? null
          : (selectedIndex ?? this.selectedIndex),
      toastMessage: toastMessage,
      segmentIndex: segmentIndex ?? this.segmentIndex,
      query: query ?? this.query,
      categoryFilter: clearCategory
          ? null
          : (categoryFilter ?? this.categoryFilter),
      loading: loading ?? this.loading,
      posting: posting ?? this.posting,
      refreshing: refreshing ?? this.refreshing,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    allPlaces,
    places,
    selectedIndex,
    toastMessage,
    segmentIndex,
    query,
    categoryFilter,
    loading,
    posting,
    refreshing,
    errorMessage,
  ];
}
