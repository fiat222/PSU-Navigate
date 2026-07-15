import '../../models/place_discussion.dart';

abstract class PlaceRepository {
  Future<List<PlaceDiscussion>> fetchPlaces();
  Future<PlaceDiscussion> postComment({
    required String placeId,
    required String text,
  });
}
