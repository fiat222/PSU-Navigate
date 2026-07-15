import '../../models/comment_item.dart';
import '../../models/place_discussion.dart';
import '../mock/mock_places.dart';
import 'place_repository.dart';

class MockPlaceRepository implements PlaceRepository {
  MockPlaceRepository({Duration? delay})
    : _delay = delay ?? const Duration(milliseconds: 650);

  final Duration _delay;
  final List<PlaceDiscussion> _store = List<PlaceDiscussion>.from(mockPlaces);

  @override
  Future<List<PlaceDiscussion>> fetchPlaces() async {
    await Future<void>.delayed(_delay);
    return List<PlaceDiscussion>.unmodifiable(_store);
  }

  @override
  Future<PlaceDiscussion> postComment({
    required String placeId,
    required String text,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final index = _store.indexWhere((p) => p.id == placeId);
    if (index < 0) {
      throw StateError('Place not found: $placeId');
    }
    final place = _store[index];
    final newComment = CommentItem(
      initials: 'คุณ',
      name: 'ตัวคุณ',
      time: 'เมื่อสักครู่',
      text: text,
      likes: 0,
      replies: const [],
    );
    final updated = place.copyWith(
      comments: [newComment, ...place.comments],
      updatedAt: DateTime.now(),
    );
    _store[index] = updated;
    return updated;
  }
}
