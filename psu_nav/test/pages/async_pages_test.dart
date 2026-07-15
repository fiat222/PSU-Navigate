import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psu_nav/app/app_theme.dart';
import 'package:psu_nav/data/repositories/event_repository.dart';
import 'package:psu_nav/data/repositories/shuttle_repository.dart';
import 'package:psu_nav/models/event_item.dart';
import 'package:psu_nav/models/shuttle_route.dart';
import 'package:psu_nav/pages/events_page.dart';
import 'package:psu_nav/pages/shuttle_page.dart';

void main() {
  testWidgets('EventsPage shows retry and recovers from load failure', (
    tester,
  ) async {
    final repo = _RetryEventRepository();
    await tester.pumpWidget(
      RepositoryProvider<EventRepository>.value(
        value: repo,
        child: const MaterialApp(
          home: Scaffold(
            body: EventsPage(device: DeviceType.phone, onToast: _ignore),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('ไม่สามารถโหลดกิจกรรมได้'), findsOneWidget);
    await tester.tap(find.text('ลองใหม่'));
    await tester.pumpAndSettle();

    expect(find.text('กิจกรรมวันนี้'), findsOneWidget);
  });

  testWidgets('ShuttlePage shows retry and recovers from load failure', (
    tester,
  ) async {
    final repo = _RetryShuttleRepository();
    await tester.pumpWidget(
      RepositoryProvider<ShuttleRepository>.value(
        value: repo,
        child: const MaterialApp(
          home: Scaffold(
            body: ShuttlePage(device: DeviceType.phone, onToast: _ignore),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('ไม่สามารถโหลดข้อมูลรถรับส่งได้'), findsOneWidget);
    await tester.tap(find.text('ลองใหม่'));
    await tester.pumpAndSettle();

    expect(find.textContaining('สายทดสอบ'), findsWidgets);
  });
}

void _ignore(String _) {}

class _RetryEventRepository implements EventRepository {
  var attempts = 0;

  final event = EventItem(
    id: 'event-today',
    title: 'กิจกรรมวันนี้',
    subtitle: 'รายละเอียด',
    kind: EventKind.official,
    tags: const ['test'],
    startsAt: DateTime.now(),
    popularityScore: 1,
    interestedCount: 1,
  );

  @override
  Future<List<EventItem>> fetchEvents() async {
    attempts++;
    if (attempts == 1) throw Exception('network');
    return [event];
  }

  @override
  Future<JoinResult> joinPlan(String eventId) async {
    return JoinResult(event: event, message: 'สำเร็จ');
  }

  @override
  Future<MatchResult> randomMatch() async {
    return const MatchResult(partnerName: 'เพื่อน', message: 'สำเร็จ');
  }
}

class _RetryShuttleRepository implements ShuttleRepository {
  var attempts = 0;

  @override
  Future<List<ShuttleRoute>> fetchRoutes() async {
    attempts++;
    if (attempts == 1) throw Exception('network');
    return const [
      ShuttleRoute(
        id: 'route-test',
        label: 'สายทดสอบ',
        busNumber: 1,
        from: 'ต้นทาง',
        to: 'ปลายทาง',
        etaMinutes: 5,
        stops: [ShuttleStop(name: 'ป้ายทดสอบ', time: '09:00')],
        tags: ['test'],
        crowdedness: 0.2,
        status: ShuttleStatus.onTime,
      ),
    ];
  }

  @override
  Future<List<String>> fetchSavedStops() async => const [];
}
