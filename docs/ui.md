# UI Long Title Wrapping Plan

## Goal

Ensure every form widget can display long titles and title-like values without horizontal overflow or truncation. Long field titles, section titles, radio labels, checkbox labels, dropdown values, picker values, file names, and repeating-group labels should wrap naturally within the available width.

## Current Risk Areas

- `lib/widget/field.dart` renders the shared field title with `maxLines: 1` and `TextOverflow.ellipsis`. This truncates any long `FormFieldModel.title` before individual widgets are even considered.
- `lib/widget/section.dart` renders `sectionTitle` inside a `Row` without an `Expanded` or `Flexible`, so long section titles can overflow.
- `lib/widget/fields/radio_group_field.dart` wraps each radio option label in a plain `Container` inside nested `Row` widgets. Unlike the checkbox item, it is not constrained with `Expanded`.
- Several field widgets render selected values, hints, or file names with `maxLines` and ellipsis. Those are acceptable for compact previews only if the full value is available elsewhere; otherwise they should wrap.
- `FormSection` lays multiple weighted fields in the same `Row`. When fields are narrow, long titles need vertical wrapping and rows must stay stable without causing render overflow.

## Implementation Plan

1. Replace the shared title truncation in `DataFormField._buildFieldContent`.
   - Remove `maxLines: 1` and `overflow: TextOverflow.ellipsis` from the title `Text`.
   - Keep the title inside `Expanded`.
   - Set `softWrap: true`.
   - Let the title take as many lines as needed.
   - Keep the required marker adjacent to the title, aligned at the top for multi-line titles.

2. Update section titles to wrap.
   - In `FormSection`, wrap the `sectionTitle` `Text` with `Expanded` or replace the title `Row` with a width-constrained layout.
   - Use `softWrap: true`.
   - Avoid fixed line limits.

3. Standardize option-label layout.
   - Update `RadioItem` so the label uses `Expanded(child: Text(...))`, matching the checkbox item pattern.
   - Audit checklist, radio, and any future choice widgets for icon-plus-label rows where the label must be flexible.
   - Keep icons at fixed size and let only text consume remaining width.

4. Audit all field widgets for title-like values.
   - Check every `Text(...)` in `lib/widget/fields`.
   - Classify each one as either:
     - `label/title`: must wrap with no ellipsis.
     - `selected value preview`: may wrap to a reasonable number of lines only if the complete value can still be inspected.
     - `button/control text`: should fit through concise copy or flexible layout.
   - Prioritize these files because they already contain constrained text:
     - `date_picker_field.dart`
     - `date_range_picker_field.dart`
     - `image_picker_field.dart`
     - `barcode_scanner_field.dart`
     - `qr_scanner_field.dart`
     - `location_field.dart`
     - `file_picker_field.dart`
     - `multi_media_picker_field.dart`
     - `spinner_field.dart`
     - `repeating_group_field.dart`

5. Make multi-column rows resilient.
   - Verify field titles wrap correctly for `weight < 12`.
   - Ensure wrapped titles increase field height without overlapping the input container below.
   - If two fields in the same row have different title heights, align row children at the top and allow the row height to grow.

6. Add regression coverage.
   - Add widget tests that render every public `DataFormField` constructor with a long title.
   - Use a narrow test viewport to catch mobile-width overflow.
   - Include at least one `FormSection` with two weighted fields in the same row.
   - Include radio and checklist items with long option text.
   - Fail the test on Flutter overflow errors captured from `FlutterError.onError`.

7. Add an example scenario for manual verification.
   - Update the example app or add a dedicated example screen containing long titles and long option values.
   - Test at phone width and tablet/desktop width.
   - Confirm required markers, help text, error text, prefixes, and postfixes still align cleanly.

## Acceptance Criteria

- No field title is truncated with ellipsis.
- Long titles wrap on text, picker, scanner, media, location, bool, radio, checklist, spinner, repeating-group, and color widgets.
- Section titles wrap without overflow.
- Long radio and checklist option labels wrap beside fixed-size icons.
- Multi-column form rows do not overflow when titles wrap.
- Existing help and error message wrapping continues to work.
- Widget tests pass without Flutter overflow exceptions.

## Suggested First Code Changes

- `lib/widget/field.dart`: remove the title `maxLines` and `overflow`, and top-align the required marker.
- `lib/widget/section.dart`: constrain section title text with `Expanded`.
- `lib/widget/fields/radio_group_field.dart`: wrap the radio item label in `Expanded`.
- Tests: add a long-title regression test before auditing lower-priority selected-value previews.
