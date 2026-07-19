# Task 5: Events Extraction, Honest Copy, and Documentation

## Context

Finish Priority 3 without changing external behavior. Extract focused Events widgets, remove false external-service claims, and align README/SRS to the actual frontend prototype. Do not add dependencies or commit.

## Events Characterization and Extraction

- Extend `psu_nav/test/pages/async_pages_test.dart` or add `test/widgets/events_widgets_test.dart` to characterize random-match rendering/callback and event join callback before refactoring.
- Run the characterization test and confirm GREEN before moving code.
- Create `psu_nav/lib/widgets/events/event_card.dart` with a presentational API including `event`, `joining`, and `onJoin(String eventId)`.
- Create `psu_nav/lib/widgets/events/random_match_banner.dart` with `matching` and `onMatch`.
- Move the existing event card, random banner, mini spinner, and joining badge presentation out of `events_page.dart`. Keep Bloc dispatch in page callbacks.
- Rerun Events tests and preserve behavior.

## Honest Prototype Copy

- Audit `psu_nav/lib/` for user-facing claims including `live`, `Realtime`, `cached`, `WebSocket`, SSO, email delivery, real online users, or persisted notification/cache success.
- Update `route_generator.dart`, `place_discussion_card.dart`, Profile, Map, Events, and any other visible surfaces so inactive services are labelled `Prototype`, `mock`, `ข้อมูลตัวอย่าง`, or `session นี้`.
- Add source-copy assertions to `psu_nav/test/architecture/page_naming_test.dart` for the exact false claims removed, so they cannot regress.

## README and SRS

- Replace `psu_nav/README.md` with Thai-first documentation covering purpose, demo account `thanapon@email.psu.ac.th` / `psu1234`, features, `Page -> Bloc -> Repository -> Model`, setup, run, format, analyze, test, viewport matrix, and a table separating implemented prototype behavior from future real services.
- Update `docs/SRS.md` so current implementation says `flutter_bloc`, `Equatable`, `NavigationBloc`, `RouteGenerator`, and in-memory mock repositories.
- Move Riverpod/go_router/Google Maps/backend/WebSocket/cache/push/SSO to an explicitly future-production section where retained.
- Extend the architecture test to assert README/SRS current-prototype content contains `flutter_bloc` and `NavigationBloc` and does not describe Riverpod/go_router as current.

## Verification

Run from `psu_nav`:

1. Events characterization tests before and after extraction.
2. `rtk flutter test test/pages/async_pages_test.dart test/bloc/events_bloc_test.dart`.
3. `rtk flutter test test/architecture/page_naming_test.dart`.
4. Format touched Dart files.

## Report Contract

Write `.superpowers/sdd/task-5-report.md` with status, files changed, characterization baseline, extraction verification, copy changes, documentation changes, test results, self-review, and concerns. Do not commit.
