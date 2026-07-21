import 'package:flutter_test/flutter_test.dart';
import 'package:psu_nav/bloc/shuttle/shuttle_bloc.dart';
import 'package:psu_nav/data/repositories/shuttle_repository.dart';
import 'package:psu_nav/models/shuttle_route.dart';

void main() {
  test(
    'stop notification toggles state and reports session-only feedback',
    () async {
      final bloc = ShuttleBloc(repo: _FakeShuttleRepository());
      addTearDown(bloc.close);

      bloc.add(const ToggleStopNotify('วิศวกรรมศาสตร์ 1'));
      final enabled = await bloc.stream.first;
      expect(enabled.notifiedStops, contains('วิศวกรรมศาสตร์ 1'));
      expect(enabled.toastMessage, contains('เฉพาะเซสชันต้นแบบนี้'));
      expect(enabled.toastMessage, isNot(contains('push')));

      bloc.add(const ToggleStopNotify('วิศวกรรมศาสตร์ 1'));
      final disabled = await bloc.stream.first;
      expect(disabled.notifiedStops, isNot(contains('วิศวกรรมศาสตร์ 1')));
      expect(disabled.toastMessage, contains('เฉพาะเซสชันต้นแบบนี้'));
    },
  );

  test(
    'ShuttleBloc exposes friendly errors and clears them on retry',
    () async {
      final repo = _FakeShuttleRepository(routeFailures: 1);
      final bloc = ShuttleBloc(repo: repo);
      addTearDown(bloc.close);

      bloc.add(const LoadShuttle());
      final failed = await bloc.stream.firstWhere(
        (state) => !state.loading && state.errorMessage != null,
      );
      expect(failed.errorMessage, 'ไม่สามารถโหลดข้อมูลรถรับส่งได้');

      bloc.add(const LoadShuttle());
      final loaded = await bloc.stream.firstWhere(
        (state) => !state.loading && state.routes.isNotEmpty,
      );
      expect(loaded.errorMessage, isNull);
    },
  );
}

class _FakeShuttleRepository implements ShuttleRepository {
  _FakeShuttleRepository({this.routeFailures = 0});

  int routeFailures;

  static const route = ShuttleRoute(
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
  );

  @override
  Future<List<ShuttleRoute>> fetchRoutes() async {
    if (routeFailures > 0) {
      routeFailures--;
      throw Exception('network');
    }
    return const [route];
  }

  @override
  Future<List<String>> fetchSavedStops() async => const [];
}
