# Task 04: Field Value Text Audit

## Goal

Review text inside each field widget and decide where wrapping is required.

## Target Files

- `lib/widget/fields/date_picker_field.dart`
- `lib/widget/fields/date_range_picker_field.dart`
- `lib/widget/fields/image_picker_field.dart`
- `lib/widget/fields/barcode_scanner_field.dart`
- `lib/widget/fields/qr_scanner_field.dart`
- `lib/widget/fields/location_field.dart`
- `lib/widget/fields/file_picker_field.dart`
- `lib/widget/fields/multi_media_picker_field.dart`
- `lib/widget/fields/spinner_field.dart`
- `lib/widget/fields/repeating_group_field.dart`

## Scope

- Inspect every `Text(...)` in `lib/widget/fields`.
- Classify each text node as:
  - `label/title`: must wrap with no ellipsis.
  - `selected value preview`: may use a line limit only if the complete value can still be inspected elsewhere.
  - `button/control text`: should fit through concise copy or flexible layout.
- Remove ellipsis from text that is effectively a title or label.
- Keep compact previews only where truncation is intentional and acceptable.

## Acceptance Checks

- Title-like text wraps in all field widgets.
- Selected values do not cause horizontal overflow.
- Compact preview truncation, where retained, is intentional and documented in code review notes.
