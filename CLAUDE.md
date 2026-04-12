# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter pub get          # Install dependencies
flutter test             # Run all tests
flutter test test/path/to/test.dart  # Run a single test file
flutter analyze          # Static analysis (flutter_lints)
flutter format .         # Format code (Effective Dart style)
flutter build apk --debug  # Build debug APK (from /example)
```

## Architecture

This is a Flutter package library (`data_forms`) for building dynamic, data-driven forms. It is not an application — the `example/` directory contains a companion Flutter app for manual testing.

### Core Concepts

**Entry points:**
- `DataForm` — the main stateless widget consumers use. Accepts a list of `FormSection`s, a `FormStyle`, and an `onSubmit` callback. Wraps everything in a `ChangeNotifierProvider` backed by `StateManager`.
- `DataFormField` — a stateful widget with ~25 named factory constructors (one per field type). This is the primary extension point when adding new field types.

**Data flow:**
1. Consumers define fields via `FormFieldModel` subclasses (in `lib/model/fields_model/`)
2. `DataFormField` maps each model to a concrete field widget (in `lib/widget/fields/`)
3. Field widgets read/write state through `StateManager` (a `ChangeNotifier` key-value store)
4. `form.onSubmit()` collects `Map<String, FormFieldValue>` from `StateManager`

**Models:**
- `lib/model/fields_model/` — one class per field type, all extending `FormFieldModel`
- `lib/model/data_model/` — option/data models for pickers (spinner, date, radio, etc.)
- `lib/model/response/` — response models (e.g., `PositionResponse` for location fields)

**Styling:**
- `FormStyle` in `lib/core/` is the single styling API. Consumers pass one instance to `DataForm`; field widgets read it via `Provider` or constructor injection.
- Default themes live in `lib/values/theme.dart`.

**Enums:**
- `FormFieldTypeEnum` — one case per supported field type; drives the factory dispatch in `DataFormField`
- `FormFieldStatusEnum` — field visibility/enabled states

### Adding a New Field Type

1. Add a case to `FormFieldTypeEnum`
2. Create a model in `lib/model/fields_model/` extending `FormFieldModel`
3. Create a widget in `lib/widget/fields/`
4. Add a factory constructor to `DataFormField` that maps the new model to the new widget
5. Export the model from `lib/data_forms.dart`

### Field Dependencies

Fields support a `dependsOn` parameter. Dependent fields react to state changes via `StateManager`. The `FormFieldCallBack` interface in `lib/core/` is the contract for validation callbacks.

### Responsive Layout

Fields accept a `weight` parameter (1–12) implementing a 12-column grid layout within form sections.
