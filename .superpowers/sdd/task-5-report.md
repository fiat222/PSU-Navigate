# Task 5 Report: Events Extraction, Honest Copy, and Documentation

## Status

Complete. Events presentation was extracted without moving Bloc dispatch into widgets, inactive-service claims were removed from visible prototype copy, and README/SRS now describe the implementation that exists in the repository.

## Files Changed

### Events extraction and characterization

- `psu_nav/lib/pages/events_page.dart`
- `psu_nav/lib/widgets/events/event_card.dart` (new)
- `psu_nav/lib/widgets/events/random_match_banner.dart` (new)
- `psu_nav/test/pages/async_pages_test.dart`

### Honest prototype copy

- `psu_nav/lib/routes/route_generator.dart`
- `psu_nav/lib/pages/map_page.dart`
- `psu_nav/lib/pages/profile_page.dart`
- `psu_nav/lib/widgets/community/place_discussion_card.dart`
- `psu_nav/lib/data/mock/mock_events.dart`
- `psu_nav/lib/data/mock/mock_shuttles.dart`
- `psu_nav/test/architecture/page_naming_test.dart`

### Documentation

- `.gitignore`
- `psu_nav/README.md`
- `docs/SRS.md`

No Task 4 responsive test file was edited by this task.

## Characterization Baseline

Added `EventsPage renders random match and forwards callbacks` before moving production code. It characterizes:

- Plan tab rendering and random-match banner visibility.
- `randomMatch()` repository callback and pending loading presentation.
- Success toast forwarding after match completion.
- Join action forwarding the exact `event-plan` ID.
- Pending joining badge and success toast forwarding.

Baseline command before extraction:

```text
rtk flutter test test/pages/async_pages_test.dart
```

Result: GREEN, 3/3 tests passed.

## Extraction Verification

- `EventCard` is presentational and accepts `event`, `joining`, and `onJoin(String eventId)`.
- `RandomMatchBanner` is presentational and accepts `matching` and `onMatch`.
- Mini spinner and joining badge presentation moved out of `events_page.dart`.
- `EventsPage` retains all `EventsBloc` dispatch callbacks.
- Global joining behavior remains the same as the characterized implementation.

## Honest Copy Changes

Removed or replaced exact claims for live map data, realtime/cached shuttle data, live community feed, Google Maps integration, WebSocket updates, online users, offline cache, JWT/SSO, and cached timestamps. Replacement copy explicitly uses `Prototype`, `mock`, `ข้อมูลตัวอย่าง`, or `session` wording.

Architecture assertions prevent these exact claims from returning:

- `Hat Yai campus · live`
- `Realtime shuttle · cached`
- `Place reviews · live feed`
- `Google Maps + PSU overlay`
- `WebSocket update`
- `ผู้ใช้ online ใน campus`
- `Offline cache`
- `JWT session · mock SSO`
- `ข้อมูล cache ล่าสุด`

The internal `LiveDot` class name remains because it is not user-facing copy or an external-service claim; it displays session notification preference state.

## Documentation Changes

- Replaced Flutter starter README with Thai-first project documentation.
- Included purpose, demo credentials, feature list, architecture flow, setup/run/format/analyze/test commands, viewport matrix, and prototype-vs-production table.
- Updated SRS current implementation to `flutter_bloc`, `Equatable`, `NavigationBloc`, `RouteGenerator`, and in-memory mock repositories.
- Moved Google Maps, backend, WebSocket, persistent cache, push/email, SSO, Riverpod, and `go_router` into an explicit future-production section.
- Added architecture tests requiring current-prototype markers and preventing Riverpod/`go_router` from being described as current.

## TDD Evidence

Architecture tests were added before copy/documentation implementation.

RED result:

- `visible prototype copy does not claim inactive services` failed on `Hat Yai campus · live`.
- `README and SRS describe the current Bloc prototype honestly` failed because `flutter_bloc` was absent.

GREEN result after implementation is recorded below.

## Verification Results

```text
rtk flutter test test/pages/async_pages_test.dart test/bloc/events_bloc_test.dart test/architecture/page_naming_test.dart
```

Final result: GREEN, 8/8 tests passed.

```text
rtk flutter analyze
```

Final result: `No issues found!`

Touched Dart files were formatted with `rtk dart format`.

## Reviewer Fixes

- Verified the original `.gitignore` rule `docs/` excluded `docs/SRS.md`, which would make the tracked architecture test fail on a clean checkout.
- Added a parent exception and a narrow allowlist chain: `!docs/`, `docs/*`, `!docs/SRS.md`.
- Verified `git status --short -- docs/SRS.md` now reports `?? docs/SRS.md`, so the SRS is deliverable, while `docs/not-deliverable.md` still matches `docs/*`.
- Tightened the architecture test so README and SRS must each contain `flutter_bloc`, `NavigationBloc`, `RouteGenerator`, and `in-memory mock`.
- Scoped the Riverpod/`go_router` guard to the SRS current-implementation portion before the future-production heading.

Review RED result:

- `README and SRS are deliverable current-prototype documentation` failed because `.gitignore` did not contain the required parent/file exceptions.

Review GREEN result:

```text
rtk flutter test test/architecture/page_naming_test.dart
```

Result: GREEN, 3/3 tests passed.

## Self-review

- Confirmed Events widgets do not import or access `EventsBloc`.
- Confirmed source audit finds none of the guarded false claims in `lib/`.
- Confirmed docs distinguish implemented prototype behavior from future integrations.
- Confirmed no dependency was added and no commit was created.
- A temporary analyzer regression identified the required `skeleton.dart` import for `EmptyState`; root cause was traced and the import restored. Fresh analyzer and tests pass afterward.

## Concerns

- Services listed in the SRS future-production section are intentionally named for planning clarity; they are explicitly marked as not implemented.
- The `cacheNote` model property name remains internal for compatibility, but every user-visible value now says `ข้อมูลตัวอย่าง` rather than claiming a persistent cache.
