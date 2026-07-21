import '../../models/event_item.dart';
import '../mock/mock_events.dart';
import 'event_repository.dart';

class MockEventRepository implements EventRepository {
  MockEventRepository({Duration? delay})
    : _delay = delay ?? const Duration(milliseconds: 500);

  final Duration _delay;
  final List<EventItem> _store = List<EventItem>.from(mockEvents);

  @override
  Future<List<EventItem>> fetchEvents() async {
    await Future<void>.delayed(_delay);
    return List<EventItem>.unmodifiable(_store);
  }

  @override
  Future<JoinResult> joinPlan(String eventId) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    final index = _store.indexWhere((e) => e.id == eventId);
    if (index < 0) {
      throw StateError('Event not found: $eventId');
    }
    final current = _store[index];
    final updated = EventItem(
      id: current.id,
      title: current.title,
      subtitle: current.subtitle,
      kind: current.kind,
      tags: current.tags,
      startsAt: current.startsAt,
      popularityScore: current.popularityScore,
      interestedCount: current.interestedCount + 1,
      icon: current.icon,
      pillLabel: current.pillLabel,
      actionLabel: current.actionLabel,
    );
    _store[index] = updated;
    return JoinResult(
      event: updated,
      message: 'ส่งความสนใจเข้าร่วม plan แล้ว (${updated.interestedCount} คน)',
    );
  }

  @override
  Future<MatchResult> randomMatch() async {
    await Future<void>.delayed(const Duration(milliseconds: 1400));
    const partners = [
      'นศ.ปี 2 คณะวิทยาศาสตร์',
      'นศ.ปี 3 คณะวิศวกรรมศาสตร์',
      'นศ.ปี 1 คณะศิลปศาสตร์',
    ];
    final pick =
        partners[DateTime.now().millisecondsSinceEpoch % partners.length];
    return MatchResult(
      partnerName: pick,
      message:
          'สุ่มคู่ตัวอย่างสำหรับ session นี้: $pick · '
          'ยังไม่มีระบบแชทใน prototype',
    );
  }
}
