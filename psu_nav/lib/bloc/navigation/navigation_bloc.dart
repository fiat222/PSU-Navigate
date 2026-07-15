import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../routes/app_routes.dart';

class NavigationState extends Equatable {
  const NavigationState({
    this.currentRoute = AppRoutes.map,
    this.isTransitioning = false,
    this.notificationsEnabled = true,
    this.pendingToast,
  });

  final String currentRoute;
  final bool isTransitioning;
  final bool notificationsEnabled;
  final String? pendingToast;

  NavigationState copyWith({
    String? currentRoute,
    bool? isTransitioning,
    bool? notificationsEnabled,
    String? pendingToast,
    bool clearToast = false,
  }) {
    return NavigationState(
      currentRoute: currentRoute ?? this.currentRoute,
      isTransitioning: isTransitioning ?? this.isTransitioning,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      pendingToast: clearToast ? null : (pendingToast ?? this.pendingToast),
    );
  }

  @override
  List<Object?> get props => [
    currentRoute,
    isTransitioning,
    notificationsEnabled,
    pendingToast,
  ];
}

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object?> get props => [];
}

class NavigateTo extends NavigationEvent {
  const NavigateTo(this.route, {this.toast});
  final String route;
  final String? toast;

  @override
  List<Object?> get props => [route, toast];
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
      if (event.route == state.currentRoute && !state.isTransitioning) return;
      emit(
        state.copyWith(
          currentRoute: event.route,
          isTransitioning: true,
          pendingToast: event.toast,
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
      emit(state.copyWith(notificationsEnabled: !state.notificationsEnabled));
    });

    on<NavigationToastShown>((event, emit) {
      emit(state.copyWith(clearToast: true));
    });
  }
}
