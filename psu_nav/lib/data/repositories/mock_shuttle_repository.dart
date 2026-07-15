import '../../models/shuttle_route.dart';
import '../mock/mock_shuttles.dart';
import 'shuttle_repository.dart';

class MockShuttleRepository implements ShuttleRepository {
  MockShuttleRepository({Duration? delay})
    : _delay = delay ?? const Duration(milliseconds: 600);

  final Duration _delay;

  @override
  Future<List<ShuttleRoute>> fetchRoutes() async {
    await Future<void>.delayed(_delay);
    return List<ShuttleRoute>.unmodifiable(mockShuttles);
  }

  @override
  Future<List<String>> fetchSavedStops() async {
    await Future<void>.delayed(_delay);
    return const ['วิศวกรรม 1', 'โรงอาหารกลาง', 'หอพักใน'];
  }
}
