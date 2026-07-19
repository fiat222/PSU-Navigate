import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../routes/app_routes.dart';

class NavigationState extends Equatable {
  const NavigationState({
    this.currentRoute = AppRoutes.map,
    this.isTransitioning = false,
    this.notificationsEnabled = true,
    this.pendingToast,
    this.indoorRoomCode,
  });

  final String currentRoute;
  final bool isTransitioning;
  final bool notificationsEnabled;
  final String? pendingToast;
  final String? indoorRoomCode;

  NavigationState copyWith({
    String? currentRoute,
    bool? isTransitioning,
    bool? notificationsEnabled,
    String? pendingToast,
    String? indoorRoomCode,
    bool clearToast = false,
    bool clearIndoorRoomCode = false,
  }) {
    return NavigationState(
      currentRoute: currentRoute ?? this.currentRoute,
      isTransitioning: isTransitioning ?? this.isTransitioning,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      pendingToast: clearToast ? null : (pendingToast ?? this.pendingToast),
      indoorRoomCode: clearIndoorRoomCode
          ? null
          : (indoorRoomCode ?? this.indoorRoomCode),
    );
  }

  @override
  List<Object?> get props => [
    currentRoute,
    isTransitioning,
    notificationsEnabled,
    pendingToast,
    indoorRoomCode,
  ];
}

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object?> get props => [];
}

class NavigateTo extends NavigationEvent {
  const NavigateTo(this.route, {this.toast, this.indoorRoomCode});
  final String route;
  final String? toast;
  final String? indoorRoomCode;

  @override
  List<Object?> get props => [route, toast, indoorRoomCode];
}

class TransitionFinished extends NavigationEvent {
  const TransitionFinished();
}

class ToggleNotifications extends NavigationEvent {
  const ToggleNotifications();
}

class NavigationToastShown extends NavigationEvent {
  const NavigationToastShown();
}

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationState()) {
    on<NavigateTo>((event, emit) {
      final indoorRoomCode = event.route == AppRoutes.indoor
          ? event.indoorRoomCode
          : null;
      if (event.route == state.currentRoute &&
          indoorRoomCode == state.indoorRoomCode &&
          !state.isTransitioning) {
        return;
      }
      emit(
        state.copyWith(
          currentRoute: event.route,
          isTransitioning: true,
          pendingToast: event.toast,
          indoorRoomCode: indoorRoomCode,
          clearIndoorRoomCode: indoorRoomCode == null,
        ),
      );
      Future<void>.delayed(const Duration(milliseconds: 220), () {
        if (isClosed) return;
        add(const TransitionFinished());
      });
    });

    on<TransitionFinished>((event, emit) {
      emit(state.copyWith(isTransitioning: false));
    });

    on<ToggleNotifications>((event, emit) {
      final enabled = !state.notificationsEnabled;
      emit(
        state.copyWith(
          notificationsEnabled: enabled,
          pendingToast: enabled
              ? 'เปิดการแจ้งเตือนแล้ว · บันทึกเฉพาะเซสชันต้นแบบนี้'
              : 'ปิดการแจ้งเตือนแล้ว · บันทึกเฉพาะเซสชันต้นแบบนี้',
        ),
      );
    });

    on<NavigationToastShown>((event, emit) {
      emit(state.copyWith(clearToast: true));
    });
  }
}
