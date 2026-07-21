import 'package:flutter_test/flutter_test.dart';
import 'package:psu_nav/bloc/events/events_bloc.dart';
import 'package:psu_nav/data/repositories/event_repository.dart';
import 'package:psu_nav/data/repositories/mock_event_repository.dart';
import 'package:psu_nav/models/event_item.dart';

void main() {
  test('EventsBloc exposes friendly errors and clears them on retry', () async {
    final repo = _FakeEventRepository(fetchFailures: 1);
    final bloc = EventsBloc(repo: repo);
    addTearDown(bloc.close);

    bloc.add(const LoadEvents());
    final failed = await bloc.stream.firstWhere(
      (state) => !state.loading && state.errorMessage != null,
    );
    expect(failed.errorMessage, 'ไม่สามารถโหลดกิจกรรมได้');

    bloc.add(const LoadEvents());
    final loaded = await bloc.stream.firstWhere(
      (state) => !state.loading && state.allEvents.isNotEmpty,
    );
    expect(loaded.errorMessage, isNull);
  });

  test('EventsBloc resets matching after a failed match', () async {
    final repo = _FakeEventRepository(matchFailures: 1);
    final bloc = EventsBloc(repo: repo);
    addTearDown(bloc.close);

    bloc.add(const RandomMatch());
    final failed = await bloc.stream.firstWhere(
      (state) => !state.matching && state.errorMessage != null,
    );

    expect(failed.errorMessage, 'จับคู่ไม่สำเร็จ กรุณาลองใหม่');
  });

  test('mock random match describes a session-only prototype result', () async {
    final result = await MockEventRepository(
      delay: Duration.zero,
    ).randomMatch();

    expect(result.partnerName, isNotEmpty);
    expect(result.message, contains(result.partnerName));
    expect(result.message, contains('session นี้'));
    expect(result.message, contains('ยังไม่มีระบบแชทใน prototype'));
  });
}

class _FakeEventRepository implements EventRepository {
  _FakeEventRepository({this.fetchFailures = 0, this.matchFailures = 0});

  int fetchFailures;
  int matchFailures;

  final event = EventItem(
    id: 'event-test',
    title: 'กิจกรรมทดสอบ',
    subtitle: 'รายละเอียด',
    kind: EventKind.activity,
    tags: const ['test'],
    startsAt: DateTime.now(),
    popularityScore: 1,
    interestedCount: 1,
  );

  @override
  Future<List<EventItem>> fetchEvents() async {
    if (fetchFailures > 0) {
      fetchFailures--;
      throw Exception('network');
    }
    return [event];
  }

  @override
  Future<JoinResult> joinPlan(String eventId) async {
    return JoinResult(event: event, message: 'เข้าร่วมแล้ว');
  }

  @override
  Future<MatchResult> randomMatch() async {
    if (matchFailures > 0) {
      matchFailures--;
      throw Exception('network');
    }
    return const MatchResult(partnerName: 'เพื่อน', message: 'จับคู่สำเร็จ');
  }
}
