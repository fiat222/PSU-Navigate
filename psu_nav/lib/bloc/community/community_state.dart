import '../../models/place_discussion.dart';

class CommunityState {
  final List<PlaceDiscussion> places;
  final PlaceDiscussion? selectedPlace;
  final String? toastMessage;

  CommunityState({
    required this.places,
    this.selectedPlace,
    this.toastMessage,
  });

  CommunityState copyWith({
    List<PlaceDiscussion>? places,
    PlaceDiscussion? selectedPlace,
    String? toastMessage,
    bool clearSelectedPlace = false,
  }) {
    return CommunityState(
      places: places ?? this.places,
      selectedPlace: clearSelectedPlace ? null : (selectedPlace ?? this.selectedPlace),
      toastMessage: toastMessage,
    );
  }
}
