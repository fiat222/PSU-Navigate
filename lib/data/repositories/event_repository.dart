import '../../models/event_item.dart';

class JoinResult {
  const JoinResult({required this.event, required this.message});
  final EventItem event;
  final String message;
}

class MatchResult {
  const MatchResult({required this.partnerName, required this.message});
  final String partnerName;
  final String message;
}

abstract class EventRepository {
  Future<List<EventItem>> fetchEvents();
  Future<JoinResult> joinPlan(String eventId);
  Future<MatchResult> randomMatch();
}
