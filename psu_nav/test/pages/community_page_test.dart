import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psu_nav/app/app_theme.dart';
import 'package:psu_nav/data/repositories/place_repository.dart';
import 'package:psu_nav/models/place_discussion.dart';
import 'package:psu_nav/pages/community_page.dart';

void main() {
  testWidgets('load failure shows retry and retry restores content', (
    tester,
  ) async {
    final repo = _PagePlaceRepository(fetchFailures: 1);

    await _pumpCommunity(tester, repo);
    await tester.pumpAndSettle();

    expect(find.text('ไม่สามารถโหลดรีวิวได้'), findsOneWidget);
    expect(find.text('ลองใหม่'), findsOneWidget);

    await tester.tap(find.text('ลองใหม่'));
    await tester.pumpAndSettle();

    expect(find.text('โรงอาหารทดสอบ'), findsOneWidget);
  });

  testWidgets('failed post keeps draft and successful retry clears it', (
    tester,
  ) async {
    final repo = _PagePlaceRepository(postFailures: 1);
    final messages = <String>[];

    await _pumpCommunity(tester, repo, messages: messages);
    await tester.pumpAndSettle();
    await tester.tap(find.text('โรงอาหารทดสอบ'));
    await tester.pumpAndSettle();

    final field = find.byType(TextField);
    await tester.enterText(field, 'ข้อความที่ไม่ควรหาย');
    await tester.tap(find.byIcon(Icons.send_outlined));
    await tester.pumpAndSettle();

    expect(find.text('ข้อความที่ไม่ควรหาย'), findsOneWidget);
    expect(messages, contains('ส่งคอมเมนต์ไม่สำเร็จ กรุณาลองใหม่'));

    await tester.tap(find.byIcon(Icons.send_outlined));
    await tester.pumpAndSettle();

    final textField = tester.widget<TextField>(field);
    expect(textField.controller?.text, isEmpty);
    expect(messages, contains('ส่งคอมเมนต์สำเร็จ'));
  });

  testWidgets('detail segments update their selected presentation', (
    tester,
  ) async {
    final repo = _PagePlaceRepository();

    await _pumpCommunity(tester, repo);
    await tester.pumpAndSettle();
    await tester.tap(find.text('โรงอาหารทดสอบ'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('รูปภาพ'));
    await tester.pump();

    final label = tester.widget<Text>(find.text('รูปภาพ'));
    expect(label.style?.color, Colors.white);
  });
}

Future<void> _pumpCommunity(
  WidgetTester tester,
  PlaceRepository repo, {
  List<String>? messages,
}) {
  return tester.pumpWidget(
    RepositoryProvider<PlaceRepository>.value(
      value: repo,
      child: MaterialApp(
        home: Scaffold(
          body: CommunityPage(
            device: DeviceType.phone,
            onToast: (message) => messages?.add(message),
          ),
        ),
      ),
    ),
  );
}

class _PagePlaceRepository implements PlaceRepository {
  _PagePlaceRepository({this.fetchFailures = 0, this.postFailures = 0});

  int fetchFailures;
  int postFailures;

  final place = PlaceDiscussion(
    id: 'p-test',
    icon: Icons.restaurant_outlined,
    name: 'โรงอาหารทดสอบ',
    subtitle: 'เปิดอยู่',
    ratingLabel: '4.5',
    statusLabel: 'คนไม่เยอะ',
    comments: const [],
    category: PlaceCategory.food,
    tags: const ['food'],
    popularityScore: 4.5,
    updatedAt: DateTime.utc(2026, 1, 1),
  );

  @override
  Future<List<PlaceDiscussion>> fetchPlaces() async {
    if (fetchFailures > 0) {
      fetchFailures--;
      throw Exception('network');
    }
    return [place];
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
    return place;
  }
}
