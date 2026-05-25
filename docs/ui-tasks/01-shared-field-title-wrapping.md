# Task 01: Shared Field Title Wrapping

## Goal

Make every `DataFormField` title wrap by fixing the shared title renderer.

## Target Files

- `lib/widget/field.dart`

## Scope

- Update `DataFormField._buildFieldContent`.
- Remove the title `Text` settings that force truncation:
  - `maxLines: 1`
  - `overflow: TextOverflow.ellipsis`
- Keep the title inside `Expanded`.
- Add or rely on default wrapping with `softWrap: true`.
- Align the required marker at the top when the title spans multiple lines.

## Acceptance Checks

- A long `FormFieldModel.title` wraps onto multiple lines.
- The required marker remains visible and aligned with the first title line.
- The input container moves down naturally and does not overlap the title.
- Existing help and error message display still works.
