import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:psu_nav/main.dart';

void main() {
  testWidgets('PSU Navigator prototype renders core navigation', (
    tester,
  ) async {
    await tester.pumpWidget(const PsuNavigatorApp());
    await tester.pump();

    expect(find.text('Campus Navigator'), findsOneWidget);
    expect(find.text('เข้าสู่ระบบ'), findsWidgets);

    await tester.tap(find.widgetWithText(FilledButton, 'เข้าสู่ระบบ'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    expect(find.text('แผนที่'), findsOneWidget);

    await tester.tap(find.text('รถ'));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('สาย 1'), findsWidgets);
  });

  testWidgets(
    'profile and shuttle preferences visibly toggle with honest copy',
    (tester) async {
      await tester.pumpWidget(const PsuNavigatorApp());
      await tester.pump();
      await tester.tap(find.widgetWithText(FilledButton, 'เข้าสู่ระบบ'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('ฉัน'));
      await tester.pumpAndSettle();
      expect(find.textContaining('เปิดอยู่'), findsOneWidget);
      expect(find.textContaining('เฉพาะเซสชันต้นแบบนี้'), findsWidgets);

      await tester.tap(find.byKey(const Key('profile-notifications-toggle')));
      await tester.pump();
      expect(find.textContaining('ปิดอยู่'), findsOneWidget);
      expect(
        find.text('ปิดการแจ้งเตือนแล้ว · บันทึกเฉพาะเซสชันต้นแบบนี้'),
        findsOneWidget,
      );

      await tester.tap(find.text('รถ'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('shuttle-engineering-notify')));
      await tester.pump();

      expect(find.byIcon(Icons.notifications_active), findsWidgets);
      expect(find.textContaining('เฉพาะเซสชันต้นแบบนี้'), findsWidgets);
      expect(find.textContaining('push notification'), findsNothing);
    },
  );
}
