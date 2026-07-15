import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../routes/app_routes.dart';

class NavigationState extends Equatable {
  const NavigationState({
    this.currentRoute = AppRoutes.map,
    this.isTransitioning = false,
    this.notificationsEnabled = true,
  });

  final String currentRoute;
  final bool isTransitioning;
  final bool notificationsEnabled;

  NavigationState copyWith({
    String? currentRoute,
    bool? isTransitioning,
    bool? notificationsEnabled,
  }) {
    return NavigationState(
      currentRoute: currentRoute ?? this.currentRoute,
      isTransitioning: isTransitioning ?? this.isTransitioning,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  @override
  List<Object?> get props => [
    currentRoute,
    isTransitioning,
    notificationsEnabled,
  ];
}

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object?> get props => [];
}

class NavigateTo extends NavigationEvent {
  const NavigateTo(this.route);
  final String route;

  @override
  List<Object?> get props => [route];
}

class TransitionFinished extends NavigationEvent {
  const TransitionFinished();
}

class ToggleNotifications extends NavigationEvent {
  const ToggleNotifications();
}

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationState()) {
    on<NavigateTo>((event, emit) {
      if (event.route == state.currentRoute) return;
      emit(state.copyWith(currentRoute: event.route, isTransitioning: true));
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
  }
}
