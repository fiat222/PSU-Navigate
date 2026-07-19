import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psu_nav/app/app_theme.dart';
import 'package:psu_nav/bloc/auth/auth_bloc.dart';
import 'package:psu_nav/bloc/navigation/navigation_bloc.dart';
import 'package:psu_nav/data/repositories/mock_auth_repository.dart';
import 'package:psu_nav/pages/auth/authenticated_shell.dart';
import 'package:psu_nav/pages/indoor_page.dart';
import 'package:psu_nav/pages/map_page.dart';
import 'package:psu_nav/routes/app_routes.dart';

void main() {
  testWidgets('map search navigates for supported prototype destination', (
    tester,
  ) async {
    String? route;
    String? feedback;
    await tester.pumpWidget(
      _pageHarness(
        MapPage(
          device: DeviceType.phone,
          onSectionChanged: (next, {toast, indoorRoomCode}) {
            route = next;
            feedback = toast;
          },
          onToast: (message) => feedback = message,
        ),
      ),
    );

    await tester.enterText(
      find.descendant(
        of: find.byKey(const Key('map-search-field')),
        matching: find.byType(TextField),
      ),
      'รถ',
    );
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();

    expect(route, AppRoutes.shuttle);
    expect(feedback, contains('Prototype: พบ'));
  });

  testWidgets('map search shows sample-data not-found feedback', (
    tester,
  ) async {
    String? route;
    String? feedback;
    await tester.pumpWidget(
      _pageHarness(
        MapPage(
          device: DeviceType.phone,
          onSectionChanged: (next, {toast, indoorRoomCode}) => route = next,
          onToast: (message) => feedback = message,
        ),
      ),
    );

    await tester.enterText(
      find.descendant(
        of: find.byKey(const Key('map-search-field')),
        matching: find.byType(TextField),
      ),
      'สถานที่ที่ไม่มี',
    );
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();

    expect(route, isNull);
    expect(feedback, 'ไม่พบในข้อมูลตัวอย่าง');
  });

  testWidgets('map room search opens indoor with that room selected', (
    tester,
  ) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthBloc(repo: MockAuthRepository())),
          BlocProvider(create: (_) => NavigationBloc()),
        ],
        child: const MaterialApp(home: AuthenticatedShell()),
      ),
    );

    await tester.enterText(
      find.descendant(
        of: find.byKey(const Key('map-search-field')),
        matching: find.byType(TextField),
      ),
      'ENG-301',
    );
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.byType(IndoorPage), findsOneWidget);
    expect(find.textContaining('ENG-301 · ห้องบรรยาย 301'), findsOneWidget);
  });

  testWidgets('indoor search updates visible room details', (tester) async {
    await tester.pumpWidget(
      _pageHarness(
        IndoorPage(
          device: DeviceType.phone,
          onSectionChanged: (route, {toast, indoorRoomCode}) {},
          onToast: (_) {},
        ),
      ),
    );

    await tester.enterText(
      find.descendant(
        of: find.byKey(const Key('indoor-search-field')),
        matching: find.byType(TextField),
      ),
      'ENG-301',
    );
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();

    expect(find.textContaining('ENG-301 · ห้องบรรยาย 301'), findsOneWidget);
  });
}

Widget _pageHarness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}
