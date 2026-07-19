import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psu_nav/main.dart';
import 'package:psu_nav/models/place_discussion.dart';
import 'package:psu_nav/pages/auth/register_page.dart';
import 'package:psu_nav/pages/indoor_page.dart';
import 'package:psu_nav/widgets/auth/edit_profile_modal.dart';

void main() {
  const viewports = [
    Size(360, 640),
    Size(412, 915),
    Size(800, 1280),
    Size(1280, 800),
  ];

  for (final viewport in viewports) {
    final viewportLabel =
        '${viewport.width.toInt()}x${viewport.height.toInt()}';

    testWidgets('all primary pages render without overflow at $viewportLabel', (
      tester,
    ) async {
      _configureViewport(tester, viewport);
      await _pumpAppAndLogin(tester);

      for (final destination in const ['รถ', 'กิจกรรม', 'ชุมชน', 'ฉัน']) {
        await _tapAndCheck(tester, find.text(destination), destination);
        await tester.pump(const Duration(milliseconds: 250));
        await tester.pump(const Duration(milliseconds: 750));
        _expectNoFlutterException(tester, 'หน้า $destination');
      }
    });

    testWidgets(
      'register form and faculty dropdown remain reachable at $viewportLabel',
      (tester) async {
        _configureViewport(tester, viewport);
        await _pumpApp(tester);

        await _tapAndCheck(
          tester,
          find.text('สมัครสมาชิก'),
          'เปิดหน้าสมัครสมาชิก',
        );
        await tester.pump(const Duration(milliseconds: 300));
        _expectNoFlutterException(tester, 'หน้า สมัครสมาชิก');
        expect(find.byType(RegisterPage), findsOneWidget);

        final faculty = find.byType(DropdownButton<PlaceCategory>);
        await _scrollToAndCheck(tester, faculty, 'ช่องเลือกคณะ');
        await _tapAndCheck(tester, faculty, 'เปิดรายการคณะ');
        await tester.pump(const Duration(milliseconds: 250));
        _expectNoFlutterException(tester, 'รายการคณะ');
        expect(find.text(PlaceCategory.food.label), findsOneWidget);

        await _tapAndCheck(
          tester,
          find.text(PlaceCategory.food.label).last,
          'เลือกคณะ',
        );
        await tester.pump(const Duration(milliseconds: 250));
        _expectNoFlutterException(tester, 'ปิดรายการคณะ');
        expect(
          tester.widget<DropdownButton<PlaceCategory>>(faculty).value,
          PlaceCategory.food,
        );

        final submit = find.widgetWithText(FilledButton, 'สมัครสมาชิก');
        await _scrollToAndCheck(tester, submit, 'ปุ่มสมัครสมาชิก');
      },
    );

    testWidgets(
      'indoor entry, floors, and room search work at $viewportLabel',
      (tester) async {
        _configureViewport(tester, viewport);
        await _pumpAppAndLogin(tester);

        await _tapAndCheck(tester, find.text('เข้าอาคาร'), 'เข้าอาคาร');
        await tester.pump(const Duration(milliseconds: 250));
        _expectNoFlutterException(tester, 'การเปลี่ยนหน้า Indoor');
        expect(find.byType(IndoorPage), findsOneWidget);

        await _tapAndCheck(tester, find.text('ชั้น 1'), 'เลือกชั้น 1');
        expect(
          tester
              .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'ชั้น 1'))
              .selected,
          isTrue,
        );

        await _tapAndCheck(tester, find.text('ชั้น 3'), 'เลือกชั้น 3');
        expect(
          tester
              .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'ชั้น 3'))
              .selected,
          isTrue,
        );

        final roomSearch = find.descendant(
          of: find.byKey(const Key('indoor-search-field')),
          matching: find.byType(TextField),
        );
        await _enterTextAndCheck(tester, roomSearch, 'ENG-LAB1', 'ค้นหาห้อง');
        expect(
          tester.widget<TextField>(roomSearch).controller?.text,
          'ENG-LAB1',
        );
        await tester.testTextInput.receiveAction(TextInputAction.search);
        await tester.pump();
        _expectNoFlutterException(tester, 'ส่งคำค้นหาห้อง');
        expect(
          find.textContaining('ENG-LAB1 · ห้องแล็บคอมพิวเตอร์'),
          findsOneWidget,
        );
        expect(roomSearch, findsOneWidget);
      },
    );

    testWidgets(
      'community detail and composer remain reachable at $viewportLabel',
      (tester) async {
        _configureViewport(tester, viewport);
        await _pumpAppAndLogin(tester);
        await _openCommunity(tester);

        await _tapAndCheck(
          tester,
          find.text('โรงอาหารกลาง (ลานอิฐ)'),
          'เปิดรายละเอียดสถานที่',
        );
        expect(find.text('ล่าสุด'), findsWidgets);

        final composer = find.byType(TextField);
        await _enterTextAndCheck(
          tester,
          composer,
          'ข้อความทดสอบ',
          'พิมพ์คอมเมนต์',
        );
        expect(
          tester.widget<TextField>(composer).controller?.text,
          'ข้อความทดสอบ',
        );
        expect(find.byIcon(Icons.send_outlined).hitTestable(), findsOneWidget);
      },
    );

    testWidgets('profile and edit modal remain reachable at $viewportLabel', (
      tester,
    ) async {
      _configureViewport(tester, viewport);
      await _pumpAppAndLogin(tester);
      await _openProfile(tester);

      final edit = find.text('แก้ไขโปรไฟล์');
      await _scrollToAndCheck(tester, edit, 'ปุ่มแก้ไขโปรไฟล์');
      await _tapAndCheck(tester, edit, 'เปิดแก้ไขโปรไฟล์');
      await tester.pump(const Duration(milliseconds: 300));
      _expectNoFlutterException(tester, 'modal แก้ไขโปรไฟล์');
      expect(find.byType(EditProfileModal), findsOneWidget);

      final nameField = find.byType(TextFormField).first;
      await _enterTextAndCheck(
        tester,
        nameField,
        'ผู้ใช้ responsive',
        'แก้ไขชื่อ',
      );
      final save = find.widgetWithText(FilledButton, 'บันทึกการเปลี่ยนแปลง');
      await _scrollToAndCheck(tester, save, 'ปุ่มบันทึกโปรไฟล์');
    });

    testWidgets(
      'keyboard-visible community composer stays reachable at $viewportLabel',
      (tester) async {
        _configureViewport(tester, viewport);
        await _pumpAppAndLogin(tester);
        await _openCommunity(tester);
        await _tapAndCheck(
          tester,
          find.text('โรงอาหารกลาง (ลานอิฐ)'),
          'เปิดรายละเอียดก่อนแสดง keyboard',
        );

        final composer = find.byType(TextField);
        await _tapAndCheck(tester, composer, 'focus community composer');
        tester.view.viewInsets = const FakeViewPadding(bottom: 300);
        await tester.pump();
        _expectNoFlutterException(
          tester,
          'community composer เมื่อ keyboard แสดง',
        );
        expect(composer, findsOneWidget);
        expect(composer.hitTestable(), findsOneWidget);
        expect(find.byIcon(Icons.send_outlined).hitTestable(), findsOneWidget);
      },
    );

    testWidgets(
      'keyboard-visible edit profile form stays reachable at $viewportLabel',
      (tester) async {
        _configureViewport(tester, viewport);
        await _pumpAppAndLogin(tester);
        await _openProfile(tester);
        final edit = find.text('แก้ไขโปรไฟล์');
        await _scrollToAndCheck(tester, edit, 'ปุ่มแก้ไขโปรไฟล์');
        await _tapAndCheck(tester, edit, 'เปิด modal ก่อนแสดง keyboard');
        await tester.pump(const Duration(milliseconds: 300));
        _expectNoFlutterException(tester, 'เปิด modal แก้ไขโปรไฟล์');

        final nameField = find.byType(TextFormField).first;
        await _tapAndCheck(tester, nameField, 'focus ช่องชื่อ');
        tester.view.viewInsets = const FakeViewPadding(bottom: 300);
        await tester.pump();
        _expectNoFlutterException(tester, 'edit profile เมื่อ keyboard แสดง');
        expect(nameField, findsOneWidget);
        expect(nameField.hitTestable(), findsOneWidget);

        final save = find.widgetWithText(FilledButton, 'บันทึกการเปลี่ยนแปลง');
        await _scrollToAndCheck(tester, save, 'ปุ่มบันทึกเหนือ keyboard');
      },
    );
  }
}

void _configureViewport(WidgetTester tester, Size viewport) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = viewport;
  tester.platformDispatcher.textScaleFactorTestValue = 1.5;
  tester.view.viewInsets = FakeViewPadding.zero;
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  addTearDown(tester.view.resetViewInsets);
}

Future<void> _pumpApp(WidgetTester tester) async {
  await tester.pumpWidget(const PsuNavigatorApp());
  await tester.pump();
  _expectNoFlutterException(tester, 'เริ่มแอป');
}

Future<void> _pumpAppAndLogin(WidgetTester tester) async {
  await _pumpApp(tester);
  await _tapAndCheck(
    tester,
    find.widgetWithText(FilledButton, 'เข้าสู่ระบบ'),
    'เข้าสู่ระบบ',
  );
  await tester.pump(const Duration(milliseconds: 750));
  await tester.pump();
  _expectNoFlutterException(tester, 'หลังเข้าสู่ระบบ');
  expect(find.text('แผนที่'), findsWidgets);
}

Future<void> _openCommunity(WidgetTester tester) async {
  await _tapAndCheck(tester, find.text('ชุมชน'), 'เปิดชุมชน');
  await tester.pump(const Duration(milliseconds: 250));
  await tester.pump(const Duration(milliseconds: 700));
  await tester.pump();
  _expectNoFlutterException(tester, 'โหลดชุมชน');
  expect(find.text('โรงอาหารกลาง (ลานอิฐ)'), findsOneWidget);
}

Future<void> _openProfile(WidgetTester tester) async {
  await _tapAndCheck(tester, find.text('ฉัน'), 'เปิดโปรไฟล์');
  await tester.pump(const Duration(milliseconds: 250));
  await tester.pump();
  _expectNoFlutterException(tester, 'หน้าโปรไฟล์');
  expect(find.text('แก้ไขโปรไฟล์'), findsOneWidget);
}

Future<void> _tapAndCheck(
  WidgetTester tester,
  Finder finder,
  String interaction,
) async {
  expect(finder, findsOneWidget, reason: 'ต้องพบ control สำหรับ $interaction');
  await tester.ensureVisible(finder);
  await tester.pump();
  expect(
    finder.hitTestable(),
    findsOneWidget,
    reason: '$interaction ต้องกดได้',
  );
  await tester.tap(finder);
  await tester.pump();
  _expectNoFlutterException(tester, interaction);
}

Future<void> _enterTextAndCheck(
  WidgetTester tester,
  Finder finder,
  String text,
  String interaction,
) async {
  await _scrollToAndCheck(tester, finder, interaction);
  await tester.enterText(finder, text);
  await tester.pump();
  _expectNoFlutterException(tester, interaction);
  expect(finder, findsOneWidget, reason: '$interaction ต้องยังเข้าถึงได้');
}

Future<void> _scrollToAndCheck(
  WidgetTester tester,
  Finder finder,
  String control,
) async {
  expect(finder, findsOneWidget, reason: 'ต้องพบ $control');
  await tester.ensureVisible(finder);
  await tester.pump();
  _expectNoFlutterException(tester, 'เลื่อนไปที่ $control');
  expect(
    finder.hitTestable(),
    findsOneWidget,
    reason: '$control ต้องเข้าถึงได้',
  );
}

void _expectNoFlutterException(WidgetTester tester, String step) {
  expect(tester.takeException(), isNull, reason: '$step ต้องไม่ overflow');
}
