import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psu_nav/bloc/community/community_bloc.dart';
import 'package:psu_nav/bloc/community/community_event.dart';
import 'package:psu_nav/data/repositories/place_repository.dart';
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
    comments: const [],
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
