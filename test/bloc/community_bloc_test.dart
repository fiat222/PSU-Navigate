import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psu_nav/bloc/community/community_bloc.dart';
import 'package:psu_nav/bloc/community/community_event.dart';
import 'package:psu_nav/data/repositories/place_repository.dart';
import 'package:psu_nav/models/comment_item.dart';
import 'package:psu_nav/models/place_discussion.dart';

void main() {
  group('CommunityBloc', () {
    test('keeps the selected place identity after sorting', () async {
      final bloc = CommunityBloc(repo: _FakePlaceRepository(_places));
      addTearDown(bloc.close);

      bloc.add(const LoadPlaces());
      await bloc.stream.firstWhere(
        (state) => !state.loading && state.places.length == 2,
      );

      bloc.add(const SelectPlace('p-low'));
      await bloc.stream.firstWhere(
        (state) => state.selectedPlace?.id == 'p-low',
      );

      bloc.add(const ChangeSegment(1));
      final sorted = await bloc.stream.firstWhere(
        (state) => state.segmentIndex == 1 && state.places.first.id == 'p-high',
      );

      expect(sorted.selectedPlace?.id, 'p-low');
    });

    test('exposes a friendly load error and clears it on retry', () async {
      final repo = _FakePlaceRepository(_places, fetchFailures: 1);
      final bloc = CommunityBloc(repo: repo);
      addTearDown(bloc.close);

      bloc.add(const LoadPlaces());
      final failed = await bloc.stream.firstWhere(
        (state) => !state.loading && state.errorMessage != null,
      );
      expect(failed.errorMessage, 'ไม่สามารถโหลดรีวิวได้');

      bloc.add(const LoadPlaces());
      final loaded = await bloc.stream.firstWhere(
        (state) => !state.loading && state.places.isNotEmpty,
      );
      expect(loaded.errorMessage, isNull);
    });

    test('reports post failure and returns posting to false', () async {
      final repo = _FakePlaceRepository(_places, postFailures: 1);
      final bloc = CommunityBloc(repo: repo);
      addTearDown(bloc.close);

      bloc.add(const LoadPlaces());
      await bloc.stream.firstWhere((state) => state.places.isNotEmpty);
      bloc.add(const SelectPlace('p-low'));
      await bloc.stream.firstWhere((state) => state.selectedPlace != null);

      bloc.add(const PostComment('ข้อความที่ต้องเก็บไว้'));
      final failed = await bloc.stream.firstWhere(
        (state) => !state.posting && state.errorMessage != null,
      );

      expect(failed.errorMessage, 'ส่งคอมเมนต์ไม่สำเร็จ กรุณาลองใหม่');
    });

    test('stores rating per place for current session', () async {
      final bloc = CommunityBloc(repo: _FakePlaceRepository(_places));
      addTearDown(bloc.close);

      bloc.add(const LoadPlaces());
      await bloc.stream.firstWhere((state) => state.places.length == 2);
      bloc.add(const SelectPlace('p-low'));
      await bloc.stream.firstWhere((state) => state.selectedPlace != null);

      bloc.add(const RateSelectedPlace(5));
      final rated = await bloc.stream.firstWhere(
        (state) => state.ratingsByPlace['p-low'] == 5,
      );

      expect(rated.ratingsByPlace['p-low'], 5);
      expect(rated.toastMessage, contains('session นี้'));
    });

    test('toggles like by stable comment id', () async {
      final bloc = CommunityBloc(repo: _FakePlaceRepository(_places));
      addTearDown(bloc.close);

      bloc.add(const LoadPlaces());
      await bloc.stream.firstWhere((state) => state.places.length == 2);
      bloc.add(const ToggleCommentLike('comment-low'));
      final liked = await bloc.stream.firstWhere(
        (state) => state.likedCommentIds.contains('comment-low'),
      );

      expect(liked.likedCommentIds, contains('comment-low'));

      bloc.add(const ToggleCommentLike('comment-low'));
      final unliked = await bloc.stream.firstWhere(
        (state) => !state.likedCommentIds.contains('comment-low'),
      );
      expect(unliked.likedCommentIds, isNot(contains('comment-low')));
    });

    test('submits one reply and ignores duplicate while pending', () async {
      final bloc = CommunityBloc(repo: _FakePlaceRepository(_places));
      addTearDown(bloc.close);

      bloc.add(const LoadPlaces());
      await bloc.stream.firstWhere((state) => state.places.length == 2);
      bloc.add(const SelectPlace('p-low'));
      await bloc.stream.firstWhere((state) => state.selectedPlace != null);
      bloc.add(const StartReply('comment-low'));
      await bloc.stream.firstWhere(
        (state) => state.replyTargetId == 'comment-low',
      );

      bloc.add(const SubmitReply('คำตอบใหม่'));
      await bloc.stream.firstWhere((state) => state.replyInProgress);
      bloc.add(const SubmitReply('คำตอบซ้ำ'));
      final replied = await bloc.stream.firstWhere(
        (state) =>
            !state.replyInProgress &&
            state.selectedPlace!.comments.single.replies.isNotEmpty,
      );

      final replies = replied.selectedPlace!.comments.single.replies;
      expect(replies, hasLength(1));
      expect(replies.single.text, 'คำตอบใหม่');
      expect(replied.toastMessage, contains('Prototype'));
    });

    test('reports once after prototype delay', () async {
      final bloc = CommunityBloc(repo: _FakePlaceRepository(_places));
      addTearDown(bloc.close);

      bloc.add(const LoadPlaces());
      await bloc.stream.firstWhere((state) => state.places.length == 2);
      bloc.add(const ReportComment('comment-low'));
      await bloc.stream.firstWhere((state) => state.reportInProgress);
      bloc.add(const ReportComment('comment-low'));
      final reported = await bloc.stream.firstWhere(
        (state) =>
            !state.reportInProgress &&
            state.reportedCommentIds.contains('comment-low'),
      );

      expect(reported.reportedCommentIds, {'comment-low'});
      expect(reported.toastMessage, contains('Prototype'));
    });

    test('keeps interactions attached after sorting', () async {
      final bloc = CommunityBloc(repo: _FakePlaceRepository(_places));
      addTearDown(bloc.close);

      bloc.add(const LoadPlaces());
      await bloc.stream.firstWhere((state) => state.places.length == 2);
      bloc.add(const SelectPlace('p-low'));
      await bloc.stream.firstWhere((state) => state.selectedPlace != null);
      bloc.add(const RateSelectedPlace(3));
      await bloc.stream.firstWhere(
        (state) => state.ratingsByPlace['p-low'] == 3,
      );
      bloc.add(const ToggleCommentLike('comment-low'));
      await bloc.stream.firstWhere(
        (state) => state.likedCommentIds.contains('comment-low'),
      );

      bloc.add(const ChangeSegment(1));
      final sorted = await bloc.stream.firstWhere(
        (state) => state.places.first.id == 'p-high',
      );

      expect(sorted.ratingsByPlace['p-low'], 3);
      expect(sorted.likedCommentIds, contains('comment-low'));
    });

    test('clears reply context when changing place', () async {
      final bloc = CommunityBloc(repo: _FakePlaceRepository(_places));
      addTearDown(bloc.close);

      bloc.add(const LoadPlaces());
      await bloc.stream.firstWhere((state) => state.places.length == 2);
      bloc.add(const SelectPlace('p-low'));
      await bloc.stream.firstWhere(
        (state) => state.selectedPlace?.id == 'p-low',
      );
      bloc.add(const StartReply('comment-low'));
      await bloc.stream.firstWhere(
        (state) => state.replyTargetId == 'comment-low',
      );

      bloc.add(const DeselectPlace());
      await bloc.stream.firstWhere((state) => state.selectedPlace == null);
      bloc.add(const SelectPlace('p-high'));
      final changed = await bloc.stream.firstWhere(
        (state) => state.selectedPlace?.id == 'p-high',
      );

      expect(changed.replyTargetId, isNull);
    });
  });
}

final _places = [
  PlaceDiscussion(
    id: 'p-low',
    icon: Icons.restaurant_outlined,
    name: 'โรงอาหาร',
    subtitle: 'อาหารราคาถูก',
    ratingLabel: '4.0',
    statusLabel: 'เปิดอยู่',
    comments: const [
      CommentItem(
        id: 'comment-low',
        initials: 'TS',
        name: 'Tester',
        text: 'ความคิดเห็นเดิม',
        likes: 2,
      ),
    ],
    category: PlaceCategory.food,
    tags: const ['food'],
    popularityScore: 1,
    updatedAt: DateTime.utc(2026, 1, 1),
  ),
  PlaceDiscussion(
    id: 'p-high',
    icon: Icons.menu_book_outlined,
    name: 'ห้องสมุด',
    subtitle: 'ที่นั่งอ่านหนังสือ',
    ratingLabel: '5.0',
    statusLabel: 'เปิดอยู่',
    comments: const [],
    category: PlaceCategory.study,
    tags: const ['study'],
    popularityScore: 10,
    updatedAt: DateTime.utc(2026, 1, 2),
  ),
];

class _FakePlaceRepository implements PlaceRepository {
  _FakePlaceRepository(
    this.places, {
    this.fetchFailures = 0,
    this.postFailures = 0,
  });

  final List<PlaceDiscussion> places;
  int fetchFailures;
  int postFailures;

  @override
  Future<List<PlaceDiscussion>> fetchPlaces() async {
    if (fetchFailures > 0) {
      fetchFailures--;
      throw Exception('network');
    }
    return places;
  }

  @override
  Future<PlaceDiscussion> postComment({
    required String placeId,
    required String text,
  }) async {
    if (postFailures > 0) {
      postFailures--;
      throw Exception('network');
    }
    return places.firstWhere((place) => place.id == placeId);
  }
}
