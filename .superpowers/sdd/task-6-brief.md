# Task 6: Full Verification and Assessment Refresh

## Context

Run fresh final verification after Tasks 1–5 and update `FRONTEND_PROTOTYPE_ASSESSMENT.md` only from observed evidence. Do not claim browser/device screenshots that were not captured. Do not commit.

## Required Work

1. From `psu_nav`, run `rtk dart format --output=none --set-exit-if-changed .`. If it changes/fails formatting, run `rtk dart format .` and repeat the check.
2. Run `rtk flutter analyze`; require exit 0 and `No issues found!`.
3. Run `rtk flutter test`; require exit 0 and record the exact final test count.
4. Update `FRONTEND_PROTOTYPE_ASSESSMENT.md`:
   - mark resolved Priority 1–3 findings with exact paths;
   - update formatter/analyzer/test evidence and viewport/sub-flow coverage;
   - score UX 4/4 and total 16/16 only if all relevant tests and analyzer pass;
   - retain an explicit manual screenshot/device-renderer limitation if still unverified;
   - remove obsolete recommendations that were implemented.
5. Verify report headings/UTF-8 content and run `rtk git status --short`.
6. Confirm `outputs/` remains untouched and every other changed file belongs to the approved work.

## Report Contract

Write `.superpowers/sdd/task-6-report.md` with status, exact commands, exit codes, analyzer result, exact test count, assessment score decision, changed files, self-review, and concerns. Do not commit.
