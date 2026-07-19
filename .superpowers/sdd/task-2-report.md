# Task 2 Report

## Status

DONE

## Files Changed

- `psu_nav/lib/widgets/common/search_field.dart`
- `psu_nav/lib/pages/map_page.dart`
- `psu_nav/lib/bloc/indoor/indoor_bloc.dart`
- `psu_nav/lib/pages/indoor_page.dart`
- `psu_nav/lib/widgets/indoor/floor_plan.dart`
- `psu_nav/lib/bloc/navigation/navigation_bloc.dart`
- `psu_nav/lib/pages/auth/authenticated_shell.dart`
- `psu_nav/lib/pages/profile_page.dart`
- `psu_nav/lib/bloc/shuttle/shuttle_bloc.dart`
- `psu_nav/lib/pages/shuttle_page.dart`
- `psu_nav/test/bloc/indoor_bloc_test.dart`
- `psu_nav/test/pages/search_interaction_test.dart`
- `psu_nav/test/bloc/shuttle_bloc_test.dart`
- `psu_nav/test/widget_test.dart`
- `.superpowers/sdd/task-2-report.md`

## RED Evidence

- `rtk flutter test test/bloc/indoor_bloc_test.dart test/pages/search_interaction_test.dart --reporter expanded`
  - Exit 1. `SearchRoomRequested` and `IndoorState.searchFeedback` did not exist; Map and Indoor had no editable fields with the required stable keys.
  - The Indoor page test also exposed the existing invalid `LayoutBuilder`/`Positioned` parent-data composition in `RoomBox`, which prevented the required interaction test from rendering the page.
- `rtk flutter test test/bloc/shuttle_bloc_test.dart test/widget_test.dart --reporter expanded`
  - Exit 1. Shuttle feedback claimed push delivery and omitted session-only persistence; Profile had no visible notification state or global toggle.
- After correcting the widget test's navigation label from the guessed `โปรไฟล์` to the existing `ฉัน`, the focused preference test still exited 1 because no `เปิดอยู่` state was rendered.

## GREEN Evidence

- `rtk flutter test test/bloc/indoor_bloc_test.dart test/pages/search_interaction_test.dart --reporter expanded`
  - Exit 0; all 5 search tests passed.
- `rtk flutter test test/bloc/shuttle_bloc_test.dart test/widget_test.dart --reporter expanded`
  - Exit 0; all 4 preference/core widget tests passed.
- `rtk dart format` over all 14 touched Dart files
  - Exit 0; all touched Dart files formatted.
- `rtk flutter analyze` over all 14 touched Dart files
  - Exit 0; no issues found.

## Self-Review

- Map search is local state only, recognizes every required fixed alias, navigates supported destinations with prototype sample-data copy, and does not navigate unsupported input.
- Indoor search uses `IndoorBloc`, matches room code/title case-insensitively, updates floor and selection only on success, preserves both on failure, and clears consumed feedback.
- `SearchField` now submits with the search action and refreshes its clear control after edits and clear taps.
- `NavigationBloc.notificationsEnabled` remains the sole global notification preference; its toggle owns the session-only toast and the shell only dispatches.
- Profile visibly consumes and toggles the global notification state. Shuttle's Engineering action toggles `notifiedStops`, changes visual state, and avoids any push-delivery claim.
- `RoomBox` now uses valid Stack-compatible fractional positioning so the Indoor interaction can render; no unrelated behavior was added.
- No dependencies, commits, backend work, or unrelated Task 1 files were changed.

## Concerns

- Verification used `FLUTTER_ALREADY_LOCKED=true` because a shared Flutter process holds the global startup lock in this workspace.
- Flutter reports six newer dependency versions incompatible with current constraints; this is informational and outside Task 2 scope.

## Reviewer Follow-Up

- Strengthened `room search selects matching room and floor` by first moving to floor 1, awaiting that state, then proving the `ENG-301` search returns both the selection and floor to floor 3.
- Strengthened the profile preference widget test with an exact assertion that `AuthenticatedShell` surfaces `ปิดการแจ้งเตือนแล้ว · บันทึกเฉพาะเซสชันต้นแบบนี้` from `NavigationBloc.pendingToast`.
- `rtk flutter test test/bloc/indoor_bloc_test.dart test/widget_test.dart --reporter expanded`
  - Exit 0; all 4 affected tests passed.
- `rtk dart format test/bloc/indoor_bloc_test.dart test/widget_test.dart`
  - Exit 0; both strengthened test files formatted.
