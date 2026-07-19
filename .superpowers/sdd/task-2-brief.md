# Task 2: Search and Honest Session Preferences

## Context

Harden Map/Indoor search and Shuttle/Profile preference actions in the frontend-only Flutter prototype. Preserve Bloc and mock repositories, add no dependencies, do not commit, and follow red-green-refactor for every behavior.

## Search Requirements

- Extend `psu_nav/lib/widgets/common/search_field.dart` with optional `ValueChanged<String>? onSubmitted`, `TextInputAction.search`, stable keys passed by callers, and `setState` after text changes/clear so the clear icon is correct.
- Convert `MapPage` to local stateful search without adding a Bloc. Replace its display-only search with `SearchField` plus the existing search action layout. Fixed sample aliases must resolve at least:
  - `ENG-301`, `วิศวกรรม` -> Indoor;
  - `ป้ายรถ`, `รถ` -> Shuttle;
  - `โรงอาหาร` -> Community.
- A supported result navigates or displays `Prototype: พบ ... ในข้อมูลตัวอย่าง`; unsupported input displays `ไม่พบในข้อมูลตัวอย่าง` and does not navigate.
- Add `SearchRoomRequested(String query)` to `IndoorBloc`.
- Extend `IndoorState` with a nullable search feedback value and a clear-feedback mechanism.
- Match `IndoorRoom.code` or `title` case-insensitively; success changes both `floor` and `selectedCode`; failure preserves selection.
- Replace Indoor display-only search with editable `SearchField`, keep the back button, and surface feedback via `BlocListener`/`onToast`.

## Search Tests

- Create `psu_nav/test/bloc/indoor_bloc_test.dart`:
  - `room search selects matching room and floor`;
  - `unknown room search preserves current selection`.
- Create `psu_nav/test/pages/search_interaction_test.dart`:
  - `map search navigates for supported prototype destination`;
  - `map search shows sample-data not-found feedback`;
  - `indoor search updates visible room details`.
- Use stable field keys `map-search-field` and `indoor-search-field`.
- Observe each test fail before production edits.

## Preference Requirements

- Keep `NavigationBloc.notificationsEnabled` as the single global notification source.
- `ToggleNotifications` must also set an honest pending toast describing current prototype session persistence.
- `AuthenticatedShell._onToggleNotifications` dispatches only; remove its manual toast to avoid duplication.
- Profile consumes `NavigationBloc`, displays enabled/disabled state visibly, dispatches `ToggleNotifications`, and uses session-only copy.
- Shuttle primary notification action dispatches `ToggleStopNotify` for the visible Engineering stop instead of calling `onToast` directly. Its visual state reflects `notifiedStops`.
- Shuttle success copy must say it is saved only for the prototype session and must not claim real push notification delivery.

## Preference Tests

- Extend `psu_nav/test/bloc/shuttle_bloc_test.dart` with `stop notification toggles state and reports session-only feedback`.
- Extend `psu_nav/test/widget_test.dart` or add a focused page test for `profile and shuttle preferences visibly toggle with honest copy`.
- Observe RED, implement the minimum stateful behavior, then observe GREEN.

## Verification

Run from `psu_nav`:

1. `rtk flutter test test/bloc/indoor_bloc_test.dart test/pages/search_interaction_test.dart`.
2. `rtk flutter test test/bloc/shuttle_bloc_test.dart test/widget_test.dart`.
3. Format every touched Dart file.

## Report Contract

Write `.superpowers/sdd/task-2-report.md` with status, files changed, RED evidence, GREEN evidence/pass counts, self-review, and concerns. Do not commit.
