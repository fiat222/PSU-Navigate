import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/shuttle_repository.dart';
import '../../models/shuttle_route.dart';

class ShuttleState extends Equatable {
  const ShuttleState({
    this.allRoutes = const [],
    this.routes = const [],
    this.savedStops = const [],
    this.selectedIndex = 0,
    this.loading = true,
    this.notifiedStops = const {},
    this.toastMessage,
    this.errorMessage,
  });

  final List<ShuttleRoute> allRoutes;
  final List<ShuttleRoute> routes;
  final List<String> savedStops;
  final int selectedIndex;
  final bool loading;
  final Set<String> notifiedStops;
  final String? toastMessage;
  final String? errorMessage;

  ShuttleRoute? get currentRoute {
    if (routes.isEmpty) return null;
    final i = selectedIndex.clamp(0, routes.length - 1);
    return routes[i];
  }

  ShuttleState copyWith({
    List<ShuttleRoute>? allRoutes,
    List<ShuttleRoute>? routes,
    List<String>? savedStops,
    int? selectedIndex,
    bool? loading,
    Set<String>? notifiedStops,
    String? toastMessage,
    String? errorMessage,
  }) {
    return ShuttleState(
      allRoutes: allRoutes ?? this.allRoutes,
      routes: routes ?? this.routes,
      savedStops: savedStops ?? this.savedStops,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      loading: loading ?? this.loading,
      notifiedStops: notifiedStops ?? this.notifiedStops,
      toastMessage: toastMessage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    allRoutes,
    routes,
    savedStops,
    selectedIndex,
    loading,
    notifiedStops,
    toastMessage,
    errorMessage,
  ];
}

abstract class ShuttleEvent extends Equatable {
  const ShuttleEvent();

  @override
  List<Object?> get props => [];
}

class LoadShuttle extends ShuttleEvent {
  const LoadShuttle();
}

class SelectRoute extends ShuttleEvent {
  const SelectRoute(this.index);
  final int index;

  @override
  List<Object?> get props => [index];
}

class ToggleStopNotify extends ShuttleEvent {
  const ToggleStopNotify(this.stopId);
  final String stopId;

  @override
  List<Object?> get props => [stopId];
}

class ToastShown extends ShuttleEvent {
  const ToastShown();
}

class ShuttleBloc extends Bloc<ShuttleEvent, ShuttleState> {
  ShuttleBloc({required this.repo}) : super(const ShuttleState(loading: true)) {
    on<LoadShuttle>(_onLoad);
    on<SelectRoute>((e, emit) {
      emit(state.copyWith(selectedIndex: e.index));
    });
    on<ToggleStopNotify>((e, emit) {
      final next = Set<String>.from(state.notifiedStops);
      final enabled = !next.contains(e.stopId);
      if (enabled) {
        next.add(e.stopId);
      } else {
        next.remove(e.stopId);
      }
      emit(
        state.copyWith(
          notifiedStops: next,
          toastMessage: enabled
              ? 'เปิดการติดตามป้ายแล้ว · บันทึกเฉพาะเซสชันต้นแบบนี้'
              : 'ปิดการติดตามป้ายแล้ว · บันทึกเฉพาะเซสชันต้นแบบนี้',
        ),
      );
    });
    on<ToastShown>((e, emit) {
      emit(state.copyWith(toastMessage: null));
    });
  }

  final ShuttleRepository repo;

  Future<void> _onLoad(LoadShuttle e, Emitter<ShuttleState> emit) async {
    emit(state.copyWith(loading: true, errorMessage: null));
    try {
      final routes = await repo.fetchRoutes();
      final saved = await repo.fetchSavedStops();
      emit(
        state.copyWith(
          loading: false,
          allRoutes: routes,
          routes: routes,
          savedStops: saved,
        ),
      );
    } catch (err) {
      emit(
        state.copyWith(
          loading: false,
          errorMessage: 'ไม่สามารถโหลดข้อมูลรถรับส่งได้',
        ),
      );
    }
  }
}
