import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psu_nav/main.dart';

void main() {
  testWidgets('login error remains visible until the next submit', (
    tester,
  ) async {
    await tester.pumpWidget(const PsuNavigatorApp());
    await tester.pump();

    await tester.enterText(find.byType(TextFormField).at(1), 'wrongpass');
    await tester.tap(find.widgetWithText(FilledButton, 'เข้าสู่ระบบ'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pump();

    expect(find.text('รหัสผ่านไม่ถูกต้อง'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    expect(find.text('รหัสผ่านไม่ถูกต้อง'), findsOneWidget);
  });
}
