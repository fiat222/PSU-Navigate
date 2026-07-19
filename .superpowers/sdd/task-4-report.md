# Task 4 Report: Complete Responsive Sub-flow Coverage

## Status

Coverage and the minimal responsive production fixes are complete. Fresh root verification is fully green.

## Files Changed

- `psu_nav/test/responsive/app_responsive_test.dart`
- `psu_nav/lib/pages/auth/register_page.dart`
- `psu_nav/lib/widgets/auth/edit_profile_form.dart`
- `psu_nav/lib/pages/community_page.dart`
- `.superpowers/sdd/task-4-report.md`

## Viewports Covered

Every sub-flow below is parameterized across these logical viewports at text scale 1.5:

- 360×640
- 412×915
- 800×1280
- 1280×800

## Sub-flows Covered

- Baseline navigation: retains coverage for Map, Shuttle, Events, Community, and Profile without overflow.
- Register: opens the register route, reaches the faculty dropdown, opens it, selects a faculty, and reaches the submit button.
- Indoor: enters from the map card, selects floors 1 and 3, edits the room search, submits `ENG-LAB1`, and verifies the room detail remains available.
- Community: loads mock places with explicit delay pumps, opens place detail, edits the composer, and verifies the send control remains reachable.
- Profile: opens the profile page, reaches Edit Profile, opens the modal, edits the name field, and reaches the save button.
- Keyboard-visible Community: focuses the composer, applies a 300 logical-pixel bottom inset, and verifies the field and send control remain hit-testable.
- Keyboard-visible Edit Profile: focuses the name field, applies a 300 logical-pixel bottom inset, and scrolls to the reachable save control.

## Test Helpers

- Viewport setup and teardown reset physical size, device pixel ratio, text scale, and view insets.
- Login and section-opening helpers use explicit pumps for mock repository delays and navigation transitions.
- Shared tap, text entry, and scroll helpers assert controls are present and hit-testable.
- Flutter exceptions are checked after setup and every interaction.
- No `pumpAndSettle` calls were added.

## RED Evidence and Fix

- Root command: `CI=true rtk flutter test test/responsive/app_responsive_test.dart`
- RED result: 19 passed and 9 failed.
- Register RED: the account footer `Row` had a constant intrinsic width around 513 pixels, overflowing right by 237 pixels at 360×640, 185 pixels at 412×915, and 93 pixels at the two max-width form layouts. It now follows the working Login footer pattern and uses centered `Wrap` layout.
- Edit Profile RED: the read-only email row overflowed right by 206 pixels at 360×640 and 154 pixels at 412×915, including keyboard coverage. The label/value column is now `Expanded`, with single-line ellipsis.
- Community keyboard RED: the detail column overflowed bottom by 172 pixels at 360×640 with a 300-pixel bottom inset. `MediaQuery.viewInsetsOf(context)` is zero inside the resized Scaffold body, so keyboard detection cannot control this layout. The toolbar and detail segments now live in a loose `Flexible` containing a `SingleChildScrollView`; the comment list remains `Expanded` and the composer fixed, allowing chrome to shrink from the actual height constraint without viewport or keyboard magic.
- The fixes use adaptive constraints and keyboard state only; no viewport-specific layout values were introduced.

## Verification

- `rtk dart format test/responsive/app_responsive_test.dart`: passed; one file formatted.
- Initial isolated responsive test file: 19 passed, 9 failed.
- After the first fixes: 23 passed, 5 failed; all Edit Profile failures were resolved, while all Register failures and the 360×640 Community keyboard failure remained.
- After the Register `Wrap` fix: its overflows were resolved; four Register cases remained test-only failures because the selected dropdown value and closing route legitimately exposed two matching `อาหาร` text widgets. The regression now asserts `DropdownButton.value == PlaceCategory.food` instead of text cardinality.
- Post-fix `test/responsive/app_responsive_test.dart`: 28/28 passed.
- Full `test/responsive` suite: 29/29 passed.
- Final pass count: 29 passed, 0 failed.

## Self-review

- Coverage uses the required four viewport sizes and text scale 1.5.
- Keyboard coverage uses a 300 logical-pixel test inset.
- Tests assert both absence of Flutter exceptions and continued control reachability after interactions.
- Production changes are limited to the three widgets implicated by the RED failures.
- No dependencies or commits were added.

## Concerns

- None. Both required responsive verification commands pass.
