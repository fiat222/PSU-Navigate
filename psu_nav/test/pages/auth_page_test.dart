import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psu_nav/bloc/auth/auth_bloc.dart';
import 'package:psu_nav/bloc/auth/auth_event.dart';
import 'package:psu_nav/data/repositories/auth_repository.dart';
import 'package:psu_nav/main.dart';
import 'package:psu_nav/models/place_discussion.dart';
import 'package:psu_nav/models/user_profile.dart';
import 'package:psu_nav/pages/auth/register_page.dart';
import 'package:psu_nav/widgets/auth/edit_profile_modal.dart';

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

  testWidgets('successful registration dismisses register route', (
    tester,
  ) async {
    await tester.pumpWidget(const PsuNavigatorApp());
    await tester.pump();

    await tester.tap(find.text('สมัครสมาชิก'));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'ผู้ใช้ใหม่');
    await tester.enterText(fields.at(1), '6610110001');
    await tester.tap(find.byType(DropdownButton<PlaceCategory>));
    await tester.pumpAndSettle();
    await tester.tap(find.text(PlaceCategory.values.first.label).last);
    await tester.pumpAndSettle();
    await tester.enterText(fields.at(2), 'new@email.psu.ac.th');
    await tester.enterText(fields.at(3), 'psu1234');
    await tester.enterText(fields.at(4), 'psu1234');

    final submitButton = find.widgetWithText(FilledButton, 'สมัครสมาชิก');
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pumpAndSettle();

    expect(find.byType(RegisterPage), findsNothing);
    expect(find.text('แผนที่'), findsWidgets);
  });

  testWidgets(
    'profile update failure keeps modal open, preserves input, and shows friendly error',
    (tester) async {
      final repo = _FakeAuthRepository(failProfileUpdate: true);
      final bloc = AuthBloc(repo: repo);
      addTearDown(bloc.close);
      await _authenticate(bloc);

      await tester.pumpWidget(_profileModalHarness(bloc));
      await tester.tap(find.text('เปิดแก้ไขโปรไฟล์'));
      await tester.pumpAndSettle();

      const updatedName = 'ผู้ใช้ชื่อใหม่';
      await tester.enterText(find.byType(TextFormField).first, updatedName);
      final saveButton = find.widgetWithText(
        FilledButton,
        'บันทึกการเปลี่ยนแปลง',
      );
      await tester.ensureVisible(saveButton);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(find.byType(EditProfileModal), findsOneWidget);
      expect(find.text(updatedName), findsOneWidget);
      expect(find.text('บันทึกโปรไฟล์ไม่สำเร็จ'), findsOneWidget);
    },
  );

  testWidgets(
    'profile form cancel clears stale update error before reopening',
    (tester) async {
      final repo = _FakeAuthRepository(failProfileUpdate: true);
      final bloc = AuthBloc(repo: repo);
      addTearDown(bloc.close);
      await _authenticate(bloc);

      await tester.pumpWidget(_profileModalHarness(bloc));
      await _openModalAndFailProfileUpdate(tester);
      expect(find.text('บันทึกโปรไฟล์ไม่สำเร็จ'), findsOneWidget);

      final cancelButton = find.widgetWithText(OutlinedButton, 'ยกเลิก');
      await tester.ensureVisible(cancelButton);
      await tester.tap(cancelButton);
      await tester.pumpAndSettle();

      expect(bloc.state.errorMessage, isNull);
      await tester.tap(find.text('เปิดแก้ไขโปรไฟล์'));
      await tester.pumpAndSettle();
      expect(find.text('บันทึกโปรไฟล์ไม่สำเร็จ'), findsNothing);
    },
  );

  testWidgets(
    'profile modal close clears stale update error before reopening',
    (tester) async {
      final repo = _FakeAuthRepository(failProfileUpdate: true);
      final bloc = AuthBloc(repo: repo);
      addTearDown(bloc.close);
      await _authenticate(bloc);

      await tester.pumpWidget(_profileModalHarness(bloc));
      await _openModalAndFailProfileUpdate(tester);
      expect(find.text('บันทึกโปรไฟล์ไม่สำเร็จ'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(bloc.state.errorMessage, isNull);
      await tester.tap(find.text('เปิดแก้ไขโปรไฟล์'));
      await tester.pumpAndSettle();
      expect(find.text('บันทึกโปรไฟล์ไม่สำเร็จ'), findsNothing);
    },
  );

  testWidgets(
    'profile update success closes modal and leaves one success toast for shell',
    (tester) async {
      final repo = _FakeAuthRepository();
      final bloc = AuthBloc(repo: repo);
      addTearDown(bloc.close);
      await _authenticate(bloc);

      await tester.pumpWidget(_profileModalHarness(bloc));
      await tester.tap(find.text('เปิดแก้ไขโปรไฟล์'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).first,
        'ผู้ใช้ชื่อใหม่',
      );
      final saveButton = find.widgetWithText(
        FilledButton,
        'บันทึกการเปลี่ยนแปลง',
      );
      await tester.ensureVisible(saveButton);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(find.byType(EditProfileModal), findsNothing);
      expect(bloc.state.toastMessage, 'บันทึกข้อมูลโปรไฟล์เรียบร้อย');
    },
  );

  testWidgets(
    'successful unchanged profile save closes modal and leaves toast for shell',
    (tester) async {
      final repo = _FakeAuthRepository();
      final bloc = AuthBloc(repo: repo);
      addTearDown(bloc.close);
      await _authenticate(bloc);

      await tester.pumpWidget(_profileModalHarness(bloc));
      await tester.tap(find.text('เปิดแก้ไขโปรไฟล์'));
      await tester.pumpAndSettle();

      final saveButton = find.widgetWithText(
        FilledButton,
        'บันทึกการเปลี่ยนแปลง',
      );
      await tester.ensureVisible(saveButton);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(find.byType(EditProfileModal), findsNothing);
      expect(bloc.state.toastMessage, 'บันทึกข้อมูลโปรไฟล์เรียบร้อย');
    },
  );

  test('unexpected login errors use friendly fixed copy', () async {
    final bloc = AuthBloc(
      repo: _FakeAuthRepository(failLoginUnexpectedly: true),
    );
    addTearDown(bloc.close);

    final error = bloc.stream.firstWhere((state) => state.errorMessage != null);
    bloc.add(
      const LoginRequested(
        email: 'student@email.psu.ac.th',
        password: 'psu1234',
      ),
    );

    expect(
      (await error).errorMessage,
      'ไม่สามารถเข้าสู่ระบบได้ กรุณาลองใหม่อีกครั้ง',
    );
  });

  test('unexpected registration errors use friendly fixed copy', () async {
    final bloc = AuthBloc(
      repo: _FakeAuthRepository(failRegistrationUnexpectedly: true),
    );
    addTearDown(bloc.close);

    final error = bloc.stream.firstWhere((state) => state.errorMessage != null);
    bloc.add(
      const RegisterRequested(
        email: 'new@email.psu.ac.th',
        password: 'psu1234',
        fullName: 'ผู้ใช้ใหม่',
        studentId: '6610110002',
        faculty: 'อาหาร',
      ),
    );

    expect(
      (await error).errorMessage,
      'สมัครสมาชิกไม่สำเร็จ กรุณาลองใหม่อีกครั้ง',
    );
  });

  test('unexpected profile errors use friendly fixed copy', () async {
    final bloc = AuthBloc(
      repo: _FakeAuthRepository(failProfileUpdateUnexpectedly: true),
    );
    addTearDown(bloc.close);
    await _authenticate(bloc);

    final error = bloc.stream.firstWhere((state) => state.errorMessage != null);
    bloc.add(
      const ProfileUpdated(
        fullName: 'ผู้ใช้ชื่อใหม่',
        studentId: '6610110001',
        faculty: 'อาหาร',
      ),
    );

    expect(
      (await error).errorMessage,
      'ไม่สามารถบันทึกโปรไฟล์ได้ กรุณาลองใหม่อีกครั้ง',
    );
  });
}

Future<void> _authenticate(AuthBloc bloc) async {
  final authenticated = bloc.stream.firstWhere(
    (state) => state.isAuthenticated,
  );
  bloc.add(
    const LoginRequested(email: 'student@email.psu.ac.th', password: 'psu1234'),
  );
  await authenticated;
}

Future<void> _openModalAndFailProfileUpdate(WidgetTester tester) async {
  await tester.tap(find.text('เปิดแก้ไขโปรไฟล์'));
  await tester.pumpAndSettle();
  final saveButton = find.widgetWithText(FilledButton, 'บันทึกการเปลี่ยนแปลง');
  await tester.ensureVisible(saveButton);
  await tester.tap(saveButton);
  await tester.pumpAndSettle();
}

Widget _profileModalHarness(AuthBloc bloc) {
  return BlocProvider.value(
    value: bloc,
    child: MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => EditProfileModal.show(context, _testUser),
            child: const Text('เปิดแก้ไขโปรไฟล์'),
          ),
        ),
      ),
    ),
  );
}

const _testUser = UserProfile(
  id: 'test-user',
  email: 'student@email.psu.ac.th',
  fullName: 'ผู้ใช้ทดสอบ',
  studentId: '6610110001',
  faculty: 'อาหาร',
);

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({
    this.failLoginUnexpectedly = false,
    this.failRegistrationUnexpectedly = false,
    this.failProfileUpdate = false,
    this.failProfileUpdateUnexpectedly = false,
  });

  final bool failLoginUnexpectedly;
  final bool failRegistrationUnexpectedly;
  final bool failProfileUpdate;
  final bool failProfileUpdateUnexpectedly;

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    if (failLoginUnexpectedly) {
      throw Exception('raw repository details');
    }
    return const AuthSession(user: _testUser, token: 'test-token');
  }

  @override
  Future<AuthSession> register({
    required String email,
    required String password,
    required String fullName,
    required String studentId,
    required String faculty,
  }) async {
    if (failRegistrationUnexpectedly) {
      throw Exception('raw repository details');
    }
    return AuthSession(
      user: _testUser.copyWith(
        email: email,
        fullName: fullName,
        studentId: studentId,
        faculty: faculty,
      ),
      token: 'test-token',
    );
  }

  @override
  Future<UserProfile> updateProfile({
    required String fullName,
    required String studentId,
    required String faculty,
  }) async {
    if (failProfileUpdate) {
      throw const AuthFailure('บันทึกโปรไฟล์ไม่สำเร็จ');
    }
    if (failProfileUpdateUnexpectedly) {
      throw Exception('raw repository details');
    }
    return _testUser.copyWith(
      fullName: fullName,
      studentId: studentId,
      faculty: faculty,
    );
  }

  @override
  Future<void> logout() async {}
}
