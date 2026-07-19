# Task 4: Complete Responsive Sub-flow Coverage

## Context

Expand Flutter widget coverage after Tasks 1–3. Do not change production widgets unless a new test exposes a real overflow or unreachable control. Keep the existing four viewport sizes and text scale 1.5. Do not commit.

## Required Tests

Modify `psu_nav/test/responsive/app_responsive_test.dart` and only add helper files if they materially reduce setup duplication.

- Factor helpers for viewport setup/reset, login, scrolling/tapping, and `tester.takeException()` assertions.
- Cover 360×640, 412×915, 800×1280, 1280×800 at text scale 1.5.
- Add separate coverage for:
  - Register form and faculty dropdown;
  - Indoor entry, floor selection, and editable room search;
  - Community place detail and composer;
  - Profile and Edit Profile modal;
  - keyboard-visible Community composer and Edit Profile form using a test bottom inset around 300 logical pixels.
- Reset physical size, DPR, text scale, and view insets in teardown.
- Use explicit pumps around mock repository delays/navigation transitions; avoid hanging `pumpAndSettle` calls.
- After each interaction assert no Flutter exception and that the relevant field/control remains findable/reachable.

## TDD/Responsive Fix Rule

- Run the new coverage tests before production edits.
- If a new test fails due a real overflow or unreachable control, preserve the failure evidence and apply the minimum fix using `SafeArea`, scrolling, `MediaQuery.viewInsetsOf(context).bottom`, `Expanded`, `Flexible`, or `Wrap`.
- If a coverage-only test passes immediately, record it as new evidence and do not invent a production change.
- Do not add viewport-specific magic numbers beyond existing layout tokens.

## Verification

Run from `psu_nav`:

1. `rtk flutter test test/responsive/app_responsive_test.dart`.
2. `rtk flutter test test/responsive`.
3. Format touched Dart files.

## Report Contract

Write `.superpowers/sdd/task-4-report.md` with status, files changed, each viewport/sub-flow covered, any RED failure and fix, final pass count, self-review, and concerns. Do not commit.
