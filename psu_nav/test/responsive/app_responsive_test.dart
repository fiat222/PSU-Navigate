import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psu_nav/main.dart';

void main() {
  const viewports = [
    Size(360, 640),
    Size(412, 915),
    Size(800, 1280),
    Size(1280, 800),
  ];

  for (final viewport in viewports) {
    testWidgets(
      'all pages render without overflow at ${viewport.width.toInt()}x${viewport.height.toInt()}',
      (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = viewport;
        tester.platformDispatcher.textScaleFactorTestValue = 1.5;
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(
          tester.platformDispatcher.clearTextScaleFactorTestValue,
        );

        await tester.pumpWidget(const PsuNavigatorApp());
        await tester.pump();
        await tester.tap(find.widgetWithText(FilledButton, 'เข้าสู่ระบบ'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 800));
        _expectNoFlutterException(tester, 'แผนที่');

        for (final destination in const ['รถ', 'กิจกรรม', 'ชุมชน', 'ฉัน']) {
          await tester.tap(find.text(destination));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 1000));
          _expectNoFlutterException(tester, destination);
        }
      },
    );
  }
}

void _expectNoFlutterException(WidgetTester tester, String page) {
  expect(tester.takeException(), isNull, reason: 'หน้า $page ต้องไม่ overflow');
}
