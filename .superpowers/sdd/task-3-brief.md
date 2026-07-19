# Task 3: Stateful Community Interactions and Focused Widgets

## Context

Complete Community rating, like, reply, and report interactions as session-only Bloc behavior. Preserve ID-based place selection, keep replies one level deep, add no dependencies, do not commit, and follow TDD.

## Model and State

- Add required stable `id` and immutable `copyWith` to `CommentItem`.
- Update every comment/reply constructor in production and tests with stable IDs.
- Reuse existing `PlaceDiscussion.copyWith`.
- Extend `CommunityState` with immutable/cloned session state for ratings by place, liked comment IDs, reported comment IDs, reply target ID, reply-in-progress, and report-in-progress.
- Equatable props include all new fields.

## Events and Bloc

- Add `RateSelectedPlace(int rating)`, `ToggleCommentLike(String commentId)`, `StartReply(String commentId)`, `CancelReply`, `SubmitReply(String text)`, and `ReportComment(String commentId)`.
- Validate ratings 1–5 and target all interactions by stable ID, never list index.
- Rating and Like are immediate state changes.
- Reply and Report use a 250 ms Bloc-managed prototype delay and reject duplicates while active.
- Reply adds one new `CommentItem` under the selected top-level comment; nested replies do not expose another Reply action.
- Report marks the target ID for the current session and repeated report is ignored.
- All feedback states explicitly say `Prototype` or `session นี้`.

## Bloc Tests

Extend `psu_nav/test/bloc/community_bloc_test.dart` with separate tests:

- `stores rating per place for current session`;
- `toggles like by stable comment id`;
- `submits one reply and ignores duplicate while pending`;
- `reports once after prototype delay`;
- `keeps interactions attached after sorting`.

Observe RED before implementing.

## UI and Extraction

- Extract cohesive widgets only:
  - `widgets/community/community_detail_toolbar.dart`;
  - `widgets/community/community_composer.dart`;
  - `widgets/community/rating_dialog.dart`;
  - `widgets/community/comment_card.dart` if it keeps the page and existing card file focused.
- Presentational comment action API includes `isLiked`, `isReported`, `onLike`, `onReply`, `onReport`.
- Use stable keys `like-<id>`, `reply-<id>`, and `report-<id>`.
- Rating opens a bounded 1–5 dialog and dispatches the result.
- Report requires confirmation before dispatch.
- Reply changes composer context, preserves draft on failure/block, clears only after successful reply feedback, and remains one level deep.

## Page Tests

Extend `psu_nav/test/pages/community_page_test.dart`:

- `rating dialog updates visible session rating`;
- `like toggles displayed count`;
- `reply composer shows target and submitted reply`;
- `report cancellation preserves state`;
- `confirmed report disables repeated report`.

Observe RED, implement, then run Bloc and page files together until GREEN.

## Verification

Run from `psu_nav`:

1. `rtk flutter test test/bloc/community_bloc_test.dart`.
2. `rtk flutter test test/pages/community_page_test.dart`.
3. `rtk flutter test test/bloc/community_bloc_test.dart test/pages/community_page_test.dart`.
4. Format all touched Dart files.

## Report Contract

Write `.superpowers/sdd/task-3-report.md` with status, files changed, RED/GREEN commands and summaries, pass counts, self-review, and concerns. Do not commit.
