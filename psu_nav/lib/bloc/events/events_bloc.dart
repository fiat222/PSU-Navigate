import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/event_repository.dart';
import '../../models/event_item.dart';

enum EventsTab { today, week, plan, activity }

class EventsState extends Equatable {
  const EventsState({
    this.allEvents = const [],
    this.events = const [],
    this.tab = EventsTab.today,
    this.query = '',
    this.matching = false,
    this.joining = false,
    this.loading = false,
    this.errorMessage,
    this.toastMessage,
  });

  final List<EventItem> allEvents;
  final List<EventItem> events;
  final EventsTab tab;
  final String query;
  final bool matching;
  final bool joining;
  final bool loading;
  final String? errorMessage;
  final String? toastMessage;

  EventsState copyWith({
    List<EventItem>? allEvents,
    List<EventItem>? events,
    EventsTab? tab,
    String? query,
    bool? matching,
    bool? joining,
    bool? loading,
    String? errorMessage,
    String? toastMessage,
  }) {
    return EventsState(
      allEvents: allEvents ?? this.allEvents,
      events: events ?? this.events,
      tab: tab ?? this.tab,
      query: query ?? this.query,
      matching: matching ?? this.matching,
      joining: joining ?? this.joining,
      loading: loading ?? this.loading,
      errorMessage: errorMessage,
      toastMessage: toastMessage,
    );
  }

  @override
  List<Object?> get props => [
    allEvents,
    events,
    tab,
    query,
    matching,
    joining,
    loading,
    errorMessage,
    toastMessage,
  ];
}

abstract class EventsEvent extends Equatable {
  const EventsEvent();

  @override
  List<Object?> get props => [];
}

class LoadEvents extends EventsEvent {
  const LoadEvents();
}

class ChangeTab extends EventsEvent {
  const ChangeTab(this.tab);
  final EventsTab tab;

  @override
  List<Object?> get props => [tab];
}

class SearchEvents extends EventsEvent {
  const SearchEvents(this.query);
  final String query;

  @override
  List<Object?> get props => [query];
}

class RandomMatch extends EventsEvent {
  const RandomMatch();
}

class JoinPlan extends EventsEvent {
  const JoinPlan(this.eventId);
  final String eventId;

  @override
  List<Object?> get props => [eventId];
}

class ToastShown extends EventsEvent {
  const ToastShown();
}

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  EventsBloc({required this.repo}) : super(const EventsState(loading: true)) {
    on<LoadEvents>(_onLoad);
    on<ChangeTab>((e, emit) {
      emit(state.copyWith(tab: e.tab));
      _emitFiltered(emit);
    });
    on<SearchEvents>((e, emit) {
      emit(state.copyWith(query: e.query));
      _emitFiltered(emit);
    });
    on<RandomMatch>(_onRandomMatch);
    on<JoinPlan>(_onJoinPlan);
    on<ToastShown>((e, emit) {
      emit(state.copyWith(toastMessage: null));
    });
  }

  final EventRepository repo;

  Future<void> _onLoad(LoadEvents e, Emitter<EventsState> emit) async {
    emit(state.copyWith(loading: true, errorMessage: null));
    try {
      final all = await repo.fetchEvents();
      emit(state.copyWith(loading: false, allEvents: all));
      _emitFiltered(emit);
    } catch (err) {
      emit(state.copyWith(loading: false, errorMessage: err.toString()));
    }
  }

  Future<void> _onRandomMatch(RandomMatch e, Emitter<EventsState> emit) async {
    if (state.matching) return;
    emit(state.copyWith(matching: true));
    try {
      final result = await repo.randomMatch();
      emit(state.copyWith(matching: false, toastMessage: result.message));
    } catch (err) {
      emit(state.copyWith(matching: false, errorMessage: err.toString()));
    }
  }

  Future<void> _onJoinPlan(JoinPlan e, Emitter<EventsState> emit) async {
    if (state.joining) return;
    emit(state.copyWith(joining: true));
    try {
      final result = await repo.joinPlan(e.eventId);
      final newAll = state.allEvents
          .map((ev) => ev.id == result.event.id ? result.event : ev)
          .toList();
      emit(state.copyWith(joining: false, allEvents: newAll));
      _emitFiltered(emit);
      emit(state.copyWith(toastMessage: result.message));
    } catch (err) {
      emit(state.copyWith(joining: false, errorMessage: err.toString()));
    }
  }

  void _emitFiltered(Emitter<EventsState> emit) {
    emit(state.copyWith(events: _applyFilters(state.allEvents)));
  }

  /// Frontend-only filter: text search + tab category.
  List<EventItem> _applyFilters(List<EventItem> source) {
    Iterable<EventItem> view = source;

    final q = state.query.trim().toLowerCase();
    if (q.isNotEmpty) {
      view = view.where((e) {
        return e.title.toLowerCase().contains(q) ||
            e.subtitle.toLowerCase().contains(q) ||
            e.tags.any((t) => t.toLowerCase().contains(q));
      });
    }

    final list = view.toList();
    final now = DateTime.now();
    switch (state.tab) {
      case EventsTab.today:
        return list.where((e) => e.isToday).toList()
          ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
      case EventsTab.week:
        return list.where((e) => e.isThisWeek(now)).toList()
          ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
      case EventsTab.plan:
        return list.where((e) => e.kind == EventKind.plan).toList()
          ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
      case EventsTab.activity:
        return list.where((e) => e.kind == EventKind.activity).toList()
          ..sort((a, b) => b.popularityScore.compareTo(a.popularityScore));
    }
  }
}
