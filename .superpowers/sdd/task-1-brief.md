# Task 1: Authentication Completion and Profile Errors

## Context

Harden the frontend-only Flutter prototype. Preserve existing Bloc/repository architecture and user input. Do not add dependencies, backend work, commits, or unrelated refactors. Follow TDD: add each regression test, run it and observe the expected failure, then implement the minimum fix and rerun.

## Required Changes

### Registration

- Modify `psu_nav/test/pages/auth_page_test.dart` and `psu_nav/lib/pages/auth/register_page.dart`.
- Add widget test `successful registration dismisses register route`:
  - pump `PsuNavigatorApp`;
  - open Register;
  - fill name, student ID, email `new@email.psu.ac.th`, password/confirmation `psu1234`;
  - choose any `PlaceCategory` from `DropdownButton<PlaceCategory>`;
  - submit and wait for the mock repository;
  - assert `RegisterPage` is absent and authenticated bottom navigation contains `แผนที่`.
- Observe RED because Register remains pushed.
- Change Register body to `BlocConsumer<AuthBloc, AuthState>`.
- Listen only for `!previous.isAuthenticated && current.isAuthenticated` and call `Navigator.of(context).pop()`.
- Keep the existing builder UI unchanged.

### Profile Update Failure and Success

- Modify `psu_nav/test/pages/auth_page_test.dart`, `psu_nav/lib/widgets/auth/edit_profile_form.dart`, `psu_nav/lib/widgets/auth/edit_profile_modal.dart`, and `psu_nav/lib/bloc/auth/auth_bloc.dart`.
- Add a hand-written fake `AuthRepository` that can fail `updateProfile` with `AuthFailure('บันทึกโปรไฟล์ไม่สำเร็จ')`.
- Add widget test `profile update failure keeps modal open, preserves input, and shows friendly error`.
- Add widget test `profile update success closes modal and leaves one success toast for shell` if feasible at page level; otherwise directly assert the modal closes on `previous.submitting && !current.submitting && current.user != previous.user` and does not dispatch `AuthToastShown`.
- Observe RED because `EditProfileForm` does not render the error.
- Render existing `ErrorBanner(message: state.errorMessage!)` above editable profile fields.
- Do not clear controllers or close the modal on failure.
- In `EditProfileModal`, close only on a completed successful user change. Do not dispatch `AuthToastShown`; `AuthenticatedShell` owns showing and clearing the success toast.
- Replace generic Auth exception messages containing raw `$err` with friendly fixed Thai copy.

## Verification

Run from `psu_nav`:

1. `rtk flutter test test/pages/auth_page_test.dart --plain-name "successful registration dismisses register route"` and record RED then GREEN.
2. `rtk flutter test test/pages/auth_page_test.dart --plain-name "profile update failure keeps modal open, preserves input, and shows friendly error"` and record RED then GREEN.
3. `rtk flutter test test/pages/auth_page_test.dart` and confirm all auth tests pass.
4. `rtk dart format lib/pages/auth/register_page.dart lib/widgets/auth/edit_profile_form.dart lib/widgets/auth/edit_profile_modal.dart lib/bloc/auth/auth_bloc.dart test/pages/auth_page_test.dart`.

## Report Contract

Write `.superpowers/sdd/task-1-report.md` containing:

- status: `DONE`, `DONE_WITH_CONCERNS`, `NEEDS_CONTEXT`, or `BLOCKED`;
- files changed;
- RED commands and expected failure summaries;
- GREEN commands and pass counts;
- self-review findings;
- concerns or follow-up needs.
