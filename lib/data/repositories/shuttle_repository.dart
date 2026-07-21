import '../../models/shuttle_route.dart';

abstract class ShuttleRepository {
  Future<List<ShuttleRoute>> fetchRoutes();
  Future<List<String>> fetchSavedStops();
}
