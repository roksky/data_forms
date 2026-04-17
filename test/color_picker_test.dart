import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:data_forms/model/state_manager.dart';
import 'package:data_forms/core/form_style.dart';
import 'package:data_forms/enums/filed_type.dart';
import 'package:data_forms/model/fields_model/color_picker_model.dart';
import 'package:data_forms/widget/fields/color_picker_field.dart';

final _style = FormStyle();

Widget _wrap(StateManager sm, Widget child) {
  return MaterialApp(
    home: ChangeNotifierProvider<StateManager>.value(
      value: sm,
      child: Scaffold(body: SingleChildScrollView(child: child)),
    ),
  );
}

/// Finds color swatch GestureDetectors inside the Wrap palette.
Finder _dialogSwatches() => find.descendant(
      of: find.byKey(const Key('color_palette')),
      matching: find.byType(GestureDetector),
    );

void main() {
  // ── Model unit tests ────────────────────────────────────────────────────────

  group('FormColorPickerModel', () {
    test('creates with required tag and correct type', () {
      final model = FormColorPickerModel(
        tag: 'brand_color',
        type: FormFieldTypeEnum.colorPicker,
      );

      expect(model.tag, 'brand_color');
      expect(model.type, FormFieldTypeEnum.colorPicker);
      expect(model.colors, isNull);
      expect(model.value, isNull);
      expect(model.required, isNull);
    });

    test('stores optional properties correctly', () {
      final palette = [Colors.red, Colors.blue];
      final model = FormColorPickerModel(
        tag: 'highlight',
        type: FormFieldTypeEnum.colorPicker,
        title: 'Highlight Color',
        required: true,
        value: '#FF0000',
        colors: palette,
        showTitle: true,
        enableReadOnly: false,
      );

      expect(model.title, 'Highlight Color');
      expect(model.required, isTrue);
      expect(model.value, '#FF0000');
      expect(model.colors, palette);
      expect(model.showTitle, isTrue);
      expect(model.enableReadOnly, isFalse);
    });

    test('isHiddenByRule defaults to false', () {
      final model = FormColorPickerModel(tag: 'c');
      expect(model.isHiddenByRule, isFalse);
    });
  });

  // ── Widget render tests ─────────────────────────────────────────────────────

  group('FormColorPickerField renders', () {
    testWidgets('builds without error when no default value', (tester) async {
      final sm = StateManager();
      final model = FormColorPickerModel(tag: 'color');

      await tester.pumpWidget(_wrap(sm, FormColorPickerField(model, _style)));
      await tester.pump();

      expect(find.byType(FormColorPickerField), findsOneWidget);
      expect(sm.get('color'), isNull);
    });

    testWidgets('displays initial hex value when model has a value',
        (tester) async {
      final sm = StateManager();
      final model = FormColorPickerModel(tag: 'color', value: '#2196F3');

      await tester.pumpWidget(_wrap(sm, FormColorPickerField(model, _style)));
      await tester.pump();

      expect(find.text('#2196F3'), findsOneWidget);
    });

    testWidgets('renders a colorize icon', (tester) async {
      final sm = StateManager();
      final model = FormColorPickerModel(tag: 'color');

      await tester.pumpWidget(_wrap(sm, FormColorPickerField(model, _style)));
      await tester.pump();

      expect(find.byIcon(Icons.colorize), findsOneWidget);
    });
  });

  // ── Dialog open / close tests ───────────────────────────────────────────────

  group('FormColorPickerField dialog', () {
    testWidgets('opens dialog when tapped', (tester) async {
      final sm = StateManager();
      final model = FormColorPickerModel(tag: 'color');

      await tester.pumpWidget(_wrap(sm, FormColorPickerField(model, _style)));
      await tester.pump();

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Select'), findsOneWidget);
    });

    testWidgets('Cancel closes dialog without updating StateManager',
        (tester) async {
      final sm = StateManager();
      final model = FormColorPickerModel(tag: 'color');

      await tester.pumpWidget(_wrap(sm, FormColorPickerField(model, _style)));
      await tester.pump();

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      expect(sm.get('color'), isNull);
    });

    testWidgets('Select is disabled until a color swatch is chosen',
        (tester) async {
      final sm = StateManager();
      final model = FormColorPickerModel(tag: 'color');

      await tester.pumpWidget(_wrap(sm, FormColorPickerField(model, _style)));
      await tester.pump();

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      final selectButton =
          tester.widget<TextButton>(find.widgetWithText(TextButton, 'Select'));
      expect(selectButton.onPressed, isNull);
    });

    testWidgets(
        'tapping a swatch then Select stores a #RRGGBB hex in StateManager',
        (tester) async {
      final sm = StateManager();
      final model = FormColorPickerModel(
        tag: 'color',
        colors: [Colors.red, Colors.blue],
      );

      await tester.pumpWidget(_wrap(sm, FormColorPickerField(model, _style)));
      await tester.pump();

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      await tester.tap(_dialogSwatches().first);
      await tester.pump();

      await tester.ensureVisible(find.text('Select'));
      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      final stored = sm.get('color');
      expect(stored, isA<String>());
      expect((stored as String).startsWith('#'), isTrue);
      expect(stored.length, 7);
    });

    testWidgets('stored value is uppercase hex for a known color', (tester) async {
      final sm = StateManager();
      final model = FormColorPickerModel(
        tag: 'color',
        colors: [const Color(0xFF2196F3)],
      );

      await tester.pumpWidget(_wrap(sm, FormColorPickerField(model, _style)));
      await tester.pump();

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      await tester.tap(_dialogSwatches().first);
      await tester.pump();

      await tester.ensureVisible(find.text('Select'));
      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();

      expect(sm.get('color'), '#2196F3');
    });

    testWidgets('selected hex is displayed in the field after confirmation',
        (tester) async {
      final sm = StateManager();
      final model = FormColorPickerModel(
        tag: 'color',
        colors: [const Color(0xFF4CAF50)],
      );

      await tester.pumpWidget(_wrap(sm, FormColorPickerField(model, _style)));
      await tester.pump();

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      await tester.tap(_dialogSwatches().first);
      await tester.pump();

      await tester.ensureVisible(find.text('Select'));
      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();

      expect(find.text('#4CAF50'), findsOneWidget);
    });

    testWidgets('shows a check mark on the tapped swatch', (tester) async {
      final sm = StateManager();
      final model = FormColorPickerModel(
        tag: 'color',
        colors: [Colors.red, Colors.blue],
      );

      await tester.pumpWidget(_wrap(sm, FormColorPickerField(model, _style)));
      await tester.pump();

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check), findsNothing);

      await tester.tap(_dialogSwatches().first);
      await tester.pump();

      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('custom color palette shows correct number of swatches',
        (tester) async {
      final sm = StateManager();
      final palette = [Colors.red, Colors.green, Colors.blue];
      final model = FormColorPickerModel(tag: 'color', colors: palette);

      await tester.pumpWidget(_wrap(sm, FormColorPickerField(model, _style)));
      await tester.pump();

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(_dialogSwatches(), findsNWidgets(palette.length));
    });

    testWidgets('default palette has 21 swatches when colors is null',
        (tester) async {
      final sm = StateManager();
      final model = FormColorPickerModel(tag: 'color');

      await tester.pumpWidget(_wrap(sm, FormColorPickerField(model, _style)));
      await tester.pump();

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(_dialogSwatches(), findsNWidgets(21));
    });
  });

  // ── Read-only tests ─────────────────────────────────────────────────────────

  group('FormColorPickerField read-only', () {
    testWidgets('tapping does not open dialog when enableReadOnly is true',
        (tester) async {
      final sm = StateManager();
      final model = FormColorPickerModel(tag: 'color', enableReadOnly: true);

      await tester.pumpWidget(_wrap(sm, FormColorPickerField(model, _style)));
      await tester.pump();

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });
  });

  // ── getValue / isValid tests ────────────────────────────────────────────────

  group('FormColorPickerField.isValid', () {
    testWidgets('returns true when not required and nothing selected',
        (tester) async {
      final sm = StateManager();
      final model = FormColorPickerModel(tag: 'color', required: false);
      late FormColorPickerField field;

      await tester.pumpWidget(_wrap(sm, Builder(builder: (ctx) {
        field = FormColorPickerField(model, _style);
        return field;
      })));
      await tester.pump();

      expect(field.isValid(), isTrue);
    });

    testWidgets('returns false when required and nothing selected',
        (tester) async {
      final sm = StateManager();
      final model = FormColorPickerModel(tag: 'color', required: true);
      late FormColorPickerField field;

      await tester.pumpWidget(_wrap(sm, Builder(builder: (ctx) {
        field = FormColorPickerField(model, _style);
        return field;
      })));
      await tester.pump();

      expect(field.isValid(), isFalse);
    });

    testWidgets('returns true when required and model has initial value',
        (tester) async {
      final sm = StateManager();
      final model = FormColorPickerModel(
        tag: 'color',
        required: true,
        value: '#FF5722',
      );
      late FormColorPickerField field;

      await tester.pumpWidget(_wrap(sm, Builder(builder: (ctx) {
        field = FormColorPickerField(model, _style);
        return field;
      })));
      await tester.pump();

      expect(field.isValid(), isTrue);
    });

    testWidgets('returns true when required and a color is selected',
        (tester) async {
      final sm = StateManager();
      final model = FormColorPickerModel(
        tag: 'color',
        required: true,
        colors: [Colors.red],
      );
      late FormColorPickerField field;

      await tester.pumpWidget(_wrap(sm, Builder(builder: (ctx) {
        field = FormColorPickerField(model, _style);
        return field;
      })));
      await tester.pump();

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();
      await tester.tap(_dialogSwatches().first);
      await tester.pump();
      await tester.ensureVisible(find.text('Select'));
      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();

      expect(field.isValid(), isTrue);
    });
  });

  group('FormColorPickerField.getValue', () {
    testWidgets('returns null when nothing selected', (tester) async {
      final sm = StateManager();
      final model = FormColorPickerModel(tag: 'color');
      late FormColorPickerField field;

      await tester.pumpWidget(_wrap(sm, Builder(builder: (ctx) {
        field = FormColorPickerField(model, _style);
        return field;
      })));
      await tester.pump();

      expect(field.getValue().value, isNull);
    });

    testWidgets('returns the selected hex string after selection', (tester) async {
      final sm = StateManager();
      final model = FormColorPickerModel(
        tag: 'color',
        colors: [const Color(0xFFF44336)],
      );
      late FormColorPickerField field;

      await tester.pumpWidget(_wrap(sm, Builder(builder: (ctx) {
        field = FormColorPickerField(model, _style);
        return field;
      })));
      await tester.pump();

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();
      await tester.tap(_dialogSwatches().first);
      await tester.pump();
      await tester.ensureVisible(find.text('Select'));
      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();

      expect(field.getValue().value, '#F44336');
    });
  });
}
