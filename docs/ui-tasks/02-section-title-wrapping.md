# Task 02: Section Title Wrapping

## Goal

Prevent long section titles from overflowing horizontally.

## Target Files

- `lib/widget/section.dart`

## Scope

- Update the `sectionTitle` layout in `FormSection`.
- Constrain the section title text with `Expanded` or another width-aware layout.
- Use `softWrap: true`.
- Avoid fixed line limits and ellipsis for section titles.

## Acceptance Checks

- Long `sectionTitle` values wrap within the section width.
- Section title wrapping works on narrow mobile widths.
- The spacing between the title and section card remains consistent.
