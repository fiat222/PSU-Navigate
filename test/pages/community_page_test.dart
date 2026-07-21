import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psu_nav/app/app_theme.dart';
import 'package:psu_nav/data/repositories/place_repository.dart';
import 'package:psu_nav/models/comment_item.dart';
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

  testWidgets('image action explains that attachment is unavailable', (
    tester,
  ) async {
    final messages = <String>[];
    await _pumpCommunity(tester, _PagePlaceRepository(), messages: messages);
    await tester.pumpAndSettle();
    await tester.tap(find.text('โรงอาหารทดสอบ'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.image_outlined));
    await tester.pump();

    expect(messages, contains('Prototype: การแนบรูปยังไม่พร้อมใช้งาน'));
  });

  testWidgets('rating dialog updates visible session rating', (tester) async {
    await _pumpCommunity(tester, _PagePlaceRepository());
    await tester.pumpAndSettle();
    await tester.tap(find.text('โรงอาหารทดสอบ'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('community-rate-place')));
    await tester.pumpAndSettle();
    expect(find.text('ให้คะแนนสถานที่'), findsOneWidget);

    await tester.tap(find.byKey(const Key('rating-5')));
    await tester.pumpAndSettle();

    expect(find.text('คะแนน session นี้: 5 ดาว'), findsOneWidget);
  });

  testWidgets('like toggles displayed count', (tester) async {
    await _pumpCommunity(tester, _PagePlaceRepository());
    await tester.pumpAndSettle();
    await tester.tap(find.text('โรงอาหารทดสอบ'));
    await tester.pumpAndSettle();

    final like = find.byKey(const Key('like-comment-test'));
    expect(find.text('ถูกใจ 2'), findsOneWidget);
    await tester.tap(like);
    await tester.pump();
    expect(find.text('ถูกใจ 3'), findsOneWidget);

    await tester.tap(like);
    await tester.pump();
    expect(find.text('ถูกใจ 2'), findsOneWidget);
  });

  testWidgets('reply composer shows target and submitted reply', (
    tester,
  ) async {
    await _pumpCommunity(tester, _PagePlaceRepository());
    await tester.pumpAndSettle();
    await tester.tap(find.text('โรงอาหารทดสอบ'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('reply-comment-test')));
    await tester.pump();
    expect(find.text('กำลังตอบกลับ Tester'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'คำตอบจาก session');
    await tester.tap(find.byIcon(Icons.send_outlined));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pumpAndSettle();

    expect(find.text('คำตอบจาก session'), findsOneWidget);
    expect(find.text('กำลังตอบกลับ Tester'), findsNothing);
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller?.text, isEmpty);
  });

  testWidgets('report cancellation preserves state', (tester) async {
    await _pumpCommunity(tester, _PagePlaceRepository());
    await tester.pumpAndSettle();
    await tester.tap(find.text('โรงอาหารทดสอบ'));
    await tester.pumpAndSettle();

    final report = find.byKey(const Key('report-comment-test'));
    await tester.tap(report);
    await tester.pumpAndSettle();
    expect(find.text('ยืนยันการรายงาน'), findsOneWidget);
    await tester.tap(find.text('ยกเลิก'));
    await tester.pumpAndSettle();

    expect(find.text('รายงานแล้ว'), findsNothing);
    expect(report, findsOneWidget);
  });

  testWidgets('confirmed report disables repeated report', (tester) async {
    await _pumpCommunity(tester, _PagePlaceRepository());
    await tester.pumpAndSettle();
    await tester.tap(find.text('โรงอาหารทดสอบ'));
    await tester.pumpAndSettle();

    final report = find.byKey(const Key('report-comment-test'));
    await tester.tap(report);
    await tester.pumpAndSettle();
    await tester.tap(find.text('ยืนยันรายงาน'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pumpAndSettle();

    expect(find.text('รายงานแล้ว'), findsOneWidget);
    final button = tester.widget<TextButton>(report);
    expect(button.onPressed, isNull);
  });

  testWidgets('changing place clears reply context and posts normally', (
    tester,
  ) async {
    final repo = _PagePlaceRepository();
    final messages = <String>[];
    await _pumpCommunity(tester, repo, messages: messages);
    await tester.pumpAndSettle();
    await tester.tap(find.text('โรงอาหารทดสอบ'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('reply-comment-test')));
    await tester.pump();
    expect(find.text('กำลังตอบกลับ Tester'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ห้องสมุดทดสอบ'));
    await tester.pumpAndSettle();

    expect(find.text('กำลังตอบกลับ Tester'), findsNothing);
    await tester.enterText(find.byType(TextField), 'โพสต์สถานที่ใหม่');
    await tester.tap(find.byIcon(Icons.send_outlined));
    await tester.pumpAndSettle();

    expect(repo.lastPostedPlaceId, 'p-second');
    expect(messages, contains('ส่งคอมเมนต์สำเร็จ'));
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
  String? lastPostedPlaceId;

  final place = PlaceDiscussion(
    id: 'p-test',
    icon: Icons.restaurant_outlined,
    name: 'โรงอาหารทดสอบ',
    subtitle: 'เปิดอยู่',
    ratingLabel: '4.5',
    statusLabel: 'คนไม่เยอะ',
    comments: const [
      CommentItem(
        id: 'comment-test',
        initials: 'TS',
        name: 'Tester',
        text: 'ความคิดเห็นทดสอบ',
        likes: 2,
      ),
    ],
    category: PlaceCategory.food,
    tags: const ['food'],
    popularityScore: 4.5,
    updatedAt: DateTime.utc(2026, 1, 1),
  );

  final secondPlace = PlaceDiscussion(
    id: 'p-second',
    icon: Icons.menu_book_outlined,
    name: 'ห้องสมุดทดสอบ',
    subtitle: 'เปิดอยู่',
    ratingLabel: '4.8',
    statusLabel: 'มีที่นั่ง',
    comments: const [],
    category: PlaceCategory.study,
    tags: const ['study'],
    popularityScore: 4.8,
    updatedAt: DateTime.utc(2026, 1, 2),
  );

  @override
  Future<List<PlaceDiscussion>> fetchPlaces() async {
    if (fetchFailures > 0) {
      fetchFailures--;
      throw Exception('network');
    }
    return [place, secondPlace];
  }

  @override
  Future<PlaceDiscussion> postComment({
    required String placeId,
    required String text,
  }) async {
    lastPostedPlaceId = placeId;
    if (postFailures > 0) {
      postFailures--;
      throw Exception('network');
    }
    return [place, secondPlace].firstWhere((place) => place.id == placeId);
  }
}
