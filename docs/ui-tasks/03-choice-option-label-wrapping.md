# Task 03: Choice Option Label Wrapping

## Goal

Ensure long radio and checklist option labels wrap beside their icons.

## Target Files

- `lib/widget/fields/radio_group_field.dart`
- `lib/widget/fields/check_list_field.dart`

## Scope

- Update `RadioItem` so the option label is constrained with `Expanded`.
- Keep radio icons fixed-size.
- Confirm `CheckBoxItem` already uses `Expanded` for its label and still behaves correctly.
- Audit any nested `Row` around radio/checklist labels that could prevent wrapping.

## Acceptance Checks

- Long radio option labels wrap without overflow.
- Long checklist option labels wrap without overflow.
- Radio and checkbox icons stay aligned with the first line of text.
- Vertical scrolling still works for long option lists.
