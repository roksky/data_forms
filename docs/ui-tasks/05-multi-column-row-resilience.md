# Task 05: Multi-Column Row Resilience

## Goal

Make weighted form rows tolerate wrapped titles without overflow or overlap.

## Target Files

- `lib/widget/section.dart`
- `lib/widget/field.dart`

## Scope

- Verify `FormSection` rows with multiple weighted `DataFormField` children.
- Ensure row children align at the top when wrapped titles produce different field heights.
- Confirm title wrapping increases row height naturally.
- Avoid fixed heights around field title blocks.

## Acceptance Checks

- Two fields with `weight: 6` can both render long titles at mobile width without overflow.
- Fields in the same row do not overlap each other.
- Inputs remain vertically aligned in a readable way when title heights differ.
