# Task 06: Long Title Regression Tests

## Goal

Add widget tests that prevent long-title overflow regressions.

## Target Files

- `test/`

## Scope

- Add tests that render every public `DataFormField` constructor with a long title where applicable.
- Use a narrow test viewport to simulate mobile width.
- Include a `FormSection` with two weighted fields in one row.
- Include radio and checklist fields with long option labels.
- Capture Flutter render overflow errors through `FlutterError.onError`.

## Acceptance Checks

- Tests fail if Flutter reports a render overflow.
- Tests cover shared field titles, section titles, radio labels, and checklist labels.
- Existing tests continue to pass.
