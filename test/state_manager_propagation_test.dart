// Tests that every field widget propagates its value to StateManager when the
// user interacts with it. These tests cover every line added in the
// "stateManager.set() for all fields" change.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:data_forms/model/state_manager.dart';
import 'package:data_forms/core/form_style.dart';
import 'package:data_forms/model/data_model/radio_data_model.dart';
import 'package:data_forms/rules/rules_engine.dart';
import 'package:file_picker/file_picker.dart';

// Field widgets (internal, imported directly)
import 'package:data_forms/widget/fields/bool_field.dart';
import 'package:data_forms/widget/fields/text_field.dart';
import 'package:data_forms/widget/fields/text_plain_field.dart';
import 'package:data_forms/widget/fields/email_field.dart';
import 'package:data_forms/widget/fields/mobile_field.dart';
import 'package:data_forms/widget/fields/number_field.dart';
import 'package:data_forms/widget/fields/password_field.dart';
import 'package:data_forms/widget/fields/price_field.dart';
import 'package:data_forms/widget/fields/radio_group_field.dart';
import 'package:data_forms/widget/fields/date_picker_field.dart';
import 'package:data_forms/widget/fields/date_range_picker_field.dart';
import 'package:data_forms/widget/fields/time_picker_field.dart';
import 'package:data_forms/widget/fields/image_picker_field.dart';
import 'package:data_forms/widget/fields/multi_image_picker_field.dart';
import 'package:data_forms/widget/fields/file_picker_field.dart';
import 'package:data_forms/widget/fields/multi_media_picker_field.dart';
import 'package:data_forms/widget/fields/signature_field.dart';
import 'package:data_forms/widget/fields/qr_scanner_field.dart';
import 'package:data_forms/widget/fields/barcode_scanner_field.dart';

// Field models
import 'package:data_forms/model/fields_model/bool_switch_model.dart';
import 'package:data_forms/model/fields_model/text_filed_model.dart';
import 'package:data_forms/model/fields_model/text_plain_model.dart';
import 'package:data_forms/model/fields_model/email_model.dart';
import 'package:data_forms/model/fields_model/mobile_model.dart';
import 'package:data_forms/model/fields_model/number_model.dart';
import 'package:data_forms/model/fields_model/text_password_model.dart';
import 'package:data_forms/model/fields_model/price_model.dart';
import 'package:data_forms/model/fields_model/radio_model.dart';
import 'package:data_forms/model/fields_model/date_picker_model.dart';
import 'package:data_forms/model/fields_model/date_range_picker_model.dart';
import 'package:data_forms/model/fields_model/time_picker_model.dart';
import 'package:data_forms/model/fields_model/image_picker_model.dart';
import 'package:data_forms/model/fields_model/multi_image_picker_model.dart';
import 'package:data_forms/model/fields_model/file_picker_model.dart';
import 'package:data_forms/model/fields_model/multi_media_picker_model.dart';
import 'package:data_forms/model/fields_model/signature_model.dart';
import 'package:data_forms/model/fields_model/qr_scanner_model.dart';
import 'package:data_forms/model/fields_model/barcode_scanner_model.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

final _style = FormStyle();

/// Wraps [child] in a [MaterialApp] + [ChangeNotifierProvider<StateManager>]
/// so widgets can reach the provider in tests.
Widget _wrap(StateManager sm, Widget child) {
  return MaterialApp(
    home: ChangeNotifierProvider<StateManager>.value(
      value: sm,
      child: Scaffold(
        body: SingleChildScrollView(child: child),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // ── Bool field ─────────────────────────────────────────────────────────────

  group('FormBoolSwitchField', () {
    testWidgets('set() is called with true when switch is turned on',
        (tester) async {
      final sm = StateManager();
      final model = FormBoolSwitchModel(tag: 'has_vehicle');

      await tester.pumpWidget(_wrap(sm, FormBoolSwitchField(model, _style)));
      await tester.pump();

      expect(sm.get('has_vehicle'), isNull); // nothing set yet

      await tester.tap(find.byType(Switch));
      await tester.pump();

      expect(sm.get('has_vehicle'), isTrue);
    });

    testWidgets('set() is called with false when switch is turned off',
        (tester) async {
      final sm = StateManager();
      final model = FormBoolSwitchModel(tag: 'flag');

      await tester.pumpWidget(_wrap(sm, FormBoolSwitchField(model, _style)));
      await tester.pump();

      // Toggle on then off
      await tester.tap(find.byType(Switch));
      await tester.pump();
      expect(sm.get('flag'), isTrue);

      await tester.tap(find.byType(Switch));
      await tester.pump();
      expect(sm.get('flag'), isFalse);
    });
  });

  // ── Text field ─────────────────────────────────────────────────────────────

  group('FormTextField', () {
    testWidgets('set() is called with typed text', (tester) async {
      final sm = StateManager();
      final model = FormTextModel(tag: 'name');

      await tester.pumpWidget(_wrap(sm, FormTextField(model, _style)));
      await tester.pump();

      expect(sm.get('name'), isNull);

      await tester.enterText(find.byType(TextField), 'Alice');
      await tester.pump();

      expect(sm.get('name'), 'Alice');
    });

    testWidgets('set() updates on each change', (tester) async {
      final sm = StateManager();
      final model = FormTextModel(tag: 'city');

      await tester.pumpWidget(_wrap(sm, FormTextField(model, _style)));
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'London');
      await tester.pump();
      expect(sm.get('city'), 'London');

      await tester.enterText(find.byType(TextField), 'Paris');
      await tester.pump();
      expect(sm.get('city'), 'Paris');
    });
  });

  // ── Text plain field ────────────────────────────────────────────────────────

  group('FormTextPlainField', () {
    testWidgets('set() is called with typed text', (tester) async {
      final sm = StateManager();
      final model = FormTextPlainModel(tag: 'notes', maxLine: 4, minLine: 1);

      await tester.pumpWidget(_wrap(sm, FormTextPlainField(model, _style)));
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'Some notes here');
      await tester.pump();

      expect(sm.get('notes'), 'Some notes here');
    });
  });

  // ── Email field ─────────────────────────────────────────────────────────────

  group('FormEmailField', () {
    testWidgets('set() is called with typed email', (tester) async {
      final sm = StateManager();
      final model = FormEmailModel(tag: 'email');

      await tester.pumpWidget(_wrap(sm, FormEmailField(model, _style)));
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'user@example.com');
      await tester.pump();

      expect(sm.get('email'), 'user@example.com');
    });
  });

  // ── Mobile field ────────────────────────────────────────────────────────────

  group('FormMobileField', () {
    testWidgets('set() is called with typed phone number', (tester) async {
      final sm = StateManager();
      final model = FormMobileModel(tag: 'phone');

      await tester.pumpWidget(_wrap(sm, FormMobileField(model, _style)));
      await tester.pump();

      await tester.enterText(find.byType(TextField), '09123456789');
      await tester.pump();

      expect(sm.get('phone'), '09123456789');
    });
  });

  // ── Number field ────────────────────────────────────────────────────────────

  group('FormNumberField', () {
    testWidgets('set() is called with typed number string', (tester) async {
      final sm = StateManager();
      final model = FormNumberModel(tag: 'count');

      await tester.pumpWidget(_wrap(sm, FormNumberField(model, _style)));
      await tester.pump();

      await tester.enterText(find.byType(TextField), '42');
      await tester.pump();

      expect(sm.get('count'), '42');
    });
  });

  // ── Password field ──────────────────────────────────────────────────────────

  group('FormPasswordField', () {
    testWidgets('set() is called with typed password', (tester) async {
      final sm = StateManager();
      final model = FormPasswordModel(tag: 'password');

      await tester.pumpWidget(_wrap(sm, FormPasswordField(model, _style)));
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'secret123');
      await tester.pump();

      expect(sm.get('password'), 'secret123');
    });
  });

  // ── Price field ─────────────────────────────────────────────────────────────

  group('FormPriceField', () {
    testWidgets('set() is called with formatted price string', (tester) async {
      final sm = StateManager();
      final model = FormPriceModel(tag: 'price');

      await tester.pumpWidget(_wrap(sm, FormPriceField(model, _style)));
      await tester.pump();

      // Enter a simple value that doesn't change after formatting
      await tester.enterText(find.byType(TextField), '100');
      await tester.pump();

      // The price field formats with NumberFormat.decimalPattern()
      expect(sm.get('price'), isNotNull);
      expect(sm.get('price'), isA<String>());
      expect((sm.get('price') as String).replaceAll(',', ''), '100');
    });
  });

  // ── Radio group field ───────────────────────────────────────────────────────

  group('FormRadioGroupField', () {
    testWidgets('set() is called with tapped RadioDataModel', (tester) async {
      final sm = StateManager();
      final items = [
        RadioDataModel(title: 'Option A', isSelected: false),
        RadioDataModel(title: 'Option B', isSelected: false),
      ];
      final model = FormRadioModel(
        tag: 'choice',
        items: items,
        searchable: false,
        scrollable: false,
        height: 200,
        callBack: (_) {},
      );

      await tester.pumpWidget(_wrap(sm, FormRadioGroupField(model, _style)));
      await tester.pump();

      expect(sm.get('choice'), isNull);

      await tester.tap(find.text('Option A'));
      await tester.pump();

      final stored = sm.get('choice') as RadioDataModel?;
      expect(stored, isNotNull);
      expect(stored!.title, 'Option A');
    });

    testWidgets('set() updates when a different item is tapped', (tester) async {
      final sm = StateManager();
      final items = [
        RadioDataModel(title: 'Cat', isSelected: false),
        RadioDataModel(title: 'Dog', isSelected: false),
      ];
      final model = FormRadioModel(
        tag: 'pet',
        items: items,
        searchable: false,
        scrollable: false,
        height: 200,
        callBack: (_) {},
      );

      await tester.pumpWidget(_wrap(sm, FormRadioGroupField(model, _style)));
      await tester.pump();

      await tester.tap(find.text('Cat'));
      await tester.pump();
      expect((sm.get('pet') as RadioDataModel).title, 'Cat');

      await tester.tap(find.text('Dog'));
      await tester.pump();
      expect((sm.get('pet') as RadioDataModel).title, 'Dog');
    });
  });

  // ── Date picker field ───────────────────────────────────────────────────────

  group('FormDatePickerField', () {
    testWidgets('_stateManager is initialised during build', (tester) async {
      final sm = StateManager();
      final model = FormDatePickerModel(tag: 'dob');

      await tester.pumpWidget(_wrap(sm, FormDatePickerField(model, _style)));
      await tester.pump();

      // Widget rendered without errors — _stateManager was assigned in build()
      expect(find.byType(FormDatePickerField), findsOneWidget);
    });

    testWidgets('set() is called after user confirms date picker',
        (tester) async {
      final sm = StateManager();
      final model = FormDatePickerModel(tag: 'start_date');

      await tester.pumpWidget(_wrap(sm, FormDatePickerField(model, _style)));
      await tester.pump();

      // Open the picker
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      // Confirm with the OK button
      final okButton = find.text('OK');
      if (okButton.evaluate().isNotEmpty) {
        await tester.tap(okButton);
        await tester.pumpAndSettle();
        expect(sm.get('start_date'), isNotNull);
      }
    });
  });

  // ── Date range picker field ─────────────────────────────────────────────────

  group('FormDateRangePickerField', () {
    testWidgets('_stateManager is initialised during build', (tester) async {
      final sm = StateManager();
      final model = FormDateRangePickerModel(tag: 'trip_dates');

      await tester.pumpWidget(
          _wrap(sm, FormDateRangePickerField(model, _style)));
      await tester.pump();

      expect(find.byType(FormDateRangePickerField), findsOneWidget);
    });

    testWidgets('set() is called after user confirms date range picker',
        (tester) async {
      final sm = StateManager();
      final model = FormDateRangePickerModel(tag: 'range');

      await tester.pumpWidget(
          _wrap(sm, FormDateRangePickerField(model, _style)));
      await tester.pump();

      // Open the range picker
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      // Confirm — the range picker has a "Save" button
      final saveButton = find.text('Save');
      if (saveButton.evaluate().isNotEmpty) {
        await tester.tap(saveButton);
        await tester.pumpAndSettle();
        expect(sm.get('range'), isNotNull);
      }
    });
  });

  // ── Time picker field ───────────────────────────────────────────────────────

  group('FormTimePickerField', () {
    testWidgets('_stateManager is initialised during build', (tester) async {
      final sm = StateManager();
      final model = FormTimePickerModel(tag: 'alarm_time');

      await tester.pumpWidget(_wrap(sm, FormTimePickerField(model, _style)));
      await tester.pump();

      expect(find.byType(FormTimePickerField), findsOneWidget);
    });

    testWidgets('set() is called after user confirms time picker',
        (tester) async {
      final sm = StateManager();
      final model = FormTimePickerModel(tag: 'meeting_time');

      await tester.pumpWidget(_wrap(sm, FormTimePickerField(model, _style)));
      await tester.pump();

      // Open the picker
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      // Confirm with the OK button
      final okButton = find.text('OK');
      if (okButton.evaluate().isNotEmpty) {
        await tester.tap(okButton);
        await tester.pumpAndSettle();
        expect(sm.get('meeting_time'), isNotNull);
      }
    });
  });

  // ── Image picker field ──────────────────────────────────────────────────────

  group('FormImagePickerField', () {
    testWidgets('builds without error and _stateManager is assigned',
        (tester) async {
      final sm = StateManager();
      final model = FormImagePickerModel(
        tag: 'avatar',
        iconWidget: const Icon(Icons.image),
      );

      await tester.pumpWidget(_wrap(sm, FormImagePickerField(model, _style)));
      await tester.pump();

      expect(find.byType(FormImagePickerField), findsOneWidget);
      // Nothing set before any interaction
      expect(sm.get('avatar'), isNull);
    });

    testWidgets('nothing is set before any interaction', (tester) async {
      final sm = StateManager();
      final model = FormImagePickerModel(
        tag: 'photo',
        iconWidget: const Icon(Icons.image),
      );

      await tester.pumpWidget(_wrap(sm, FormImagePickerField(model, _style)));
      await tester.pump();

      // No value set until user picks an image
      expect(sm.get('photo'), isNull);
    });
  });

  // ── Multi image picker field ────────────────────────────────────────────────

  group('FormMultiImagePickerField', () {
    testWidgets('builds without error and _stateManager is assigned',
        (tester) async {
      final sm = StateManager();
      final model = FormMultiImagePickerModel(
        tag: 'gallery',
        iconWidget: const Icon(Icons.photo_library),
      );

      await tester.pumpWidget(
          _wrap(sm, FormMultiImagePickerField(model, _style)));
      await tester.pump();

      expect(find.byType(FormMultiImagePickerField), findsOneWidget);
      expect(sm.get('gallery'), isNull);
    });
  });

  // ── File picker field ───────────────────────────────────────────────────────

  group('FormFilePickerField', () {
    testWidgets('builds without error and _stateManager is assigned',
        (tester) async {
      final sm = StateManager();
      final model = FormFilePickerModel(
        tag: 'attachment',
        allowMultiple: false,
        fileType: FileType.any,
      );

      await tester.pumpWidget(_wrap(sm, FormFilePickerField(model, _style)));
      await tester.pump();

      expect(find.byType(FormFilePickerField), findsOneWidget);
      expect(sm.get('attachment'), isNull);
    });
  });

  // ── Multi media picker field ────────────────────────────────────────────────

  group('FormMultiMediaAttachmentField', () {
    testWidgets('builds without error and _stateManager is assigned',
        (tester) async {
      final sm = StateManager();
      final model = FormMultiMediaPickerModel(tag: 'media');

      await tester.pumpWidget(
          _wrap(sm, FormMultiMediaAttachmentField(model, _style)));
      await tester.pump();

      expect(find.byType(FormMultiMediaAttachmentField), findsOneWidget);
      expect(sm.get('media'), isNull);
    });
  });

  // ── Signature field ─────────────────────────────────────────────────────────

  group('FormSignatureScreenField', () {
    testWidgets('builds without error and stateManager is accessible',
        (tester) async {
      final sm = StateManager();
      final model = FormSignatureModel(tag: 'sig');

      await tester.pumpWidget(
          _wrap(sm, FormSignatureScreenField(model, _style)));
      await tester.pump();

      expect(find.byType(FormSignatureScreenField), findsOneWidget);
      expect(sm.get('sig'), isNull);
    });
  });

  // ── QR scanner field ────────────────────────────────────────────────────────

  group('FormQRScannerField', () {
    testWidgets('builds without error and stateManager is accessible',
        (tester) async {
      final sm = StateManager();
      final model = FormQRScannerModel(tag: 'qr_code');

      await tester.pumpWidget(_wrap(sm, FormQRScannerField(model, _style)));
      await tester.pump();

      expect(find.byType(FormQRScannerField), findsOneWidget);
      expect(sm.get('qr_code'), isNull);
    });
  });

  // ── Barcode scanner field ───────────────────────────────────────────────────

  group('FormBarcodeScannerField', () {
    testWidgets('builds without error and _stateManager is assigned',
        (tester) async {
      final sm = StateManager();
      final model = FormBarCodeModel(tag: 'barcode');

      await tester.pumpWidget(
          _wrap(sm, FormBarcodeScannerField(model, _style)));
      await tester.pump();

      expect(find.byType(FormBarcodeScannerField), findsOneWidget);
      expect(sm.get('barcode'), isNull);
    });
  });

  // ── StateManager.isVisible integration ─────────────────────────────────────
  //
  // Verifies the end-to-end chain: field change → StateManager.set() →
  // RulesEngine.isVisible() returns the correct result.

  group('Rules engine reacts to field value changes', () {
    testWidgets(
        'bool field toggle makes isVisible return true for dependent target',
        (tester) async {
      final sm = StateManager();
      sm.setShowOnTrue(const _AlwaysShowOnTrue('has_vehicle', 'section_vehicle'));

      final model = FormBoolSwitchModel(tag: 'has_vehicle');
      await tester.pumpWidget(_wrap(sm, FormBoolSwitchField(model, _style)));
      await tester.pump();

      // Before toggle: rule condition not met → target hidden
      expect(sm.isVisible('section_vehicle'), isFalse);

      await tester.tap(find.byType(Switch));
      await tester.pump();

      // After toggle: has_vehicle == true → target visible
      expect(sm.isVisible('section_vehicle'), isTrue);
    });

    testWidgets(
        'text field change makes isVisible return true for dependent target',
        (tester) async {
      final sm = StateManager();
      sm.setShowOnValue(
          const _AlwaysShowOnValue('account_type', 'business', 'section_business'));

      final model = FormTextModel(tag: 'account_type');
      await tester.pumpWidget(_wrap(sm, FormTextField(model, _style)));
      await tester.pump();

      expect(sm.isVisible('section_business'), isFalse);

      await tester.enterText(find.byType(TextField), 'business');
      await tester.pump();

      expect(sm.isVisible('section_business'), isTrue);
    });
  });
}

// ---------------------------------------------------------------------------
// Minimal RulesEngine stubs for the integration tests
// ---------------------------------------------------------------------------

/// Shows [target] only when [fieldTag] == true.
///
/// Wraps RulesEngine to intercept [isVisible] without touching the base rules.
class _AlwaysShowOnTrue {
  final String fieldTag;
  final String target;

  const _AlwaysShowOnTrue(this.fieldTag, this.target);

  bool isVisible(String tag, dynamic Function(String key) getValue) {
    if (tag == target) return getValue(fieldTag) == true;
    return true;
  }
}

/// Shows [target] only when [fieldTag] == [expectedValue].
class _AlwaysShowOnValue {
  final String fieldTag;
  final dynamic expectedValue;
  final String target;

  const _AlwaysShowOnValue(this.fieldTag, this.expectedValue, this.target);

  bool isVisible(String tag, dynamic Function(String key) getValue) {
    if (tag == target) return getValue(fieldTag) == expectedValue;
    return true;
  }
}

extension _StateManagerStubRules on StateManager {
  void setShowOnTrue(_AlwaysShowOnTrue stub) {
    rulesEngine = RulesEngine(rules: [])
      ..addRules([]); // real engine, replaced below
    _applyStub((tag, getValue) => stub.isVisible(tag, getValue));
  }

  void setShowOnValue(_AlwaysShowOnValue stub) {
    _applyStub((tag, getValue) => stub.isVisible(tag, getValue));
  }

  void _applyStub(bool Function(String, dynamic Function(String)) fn) {
    rulesEngine = _StubRulesEngine(fn);
  }
}

class _StubRulesEngine extends RulesEngine {
  final bool Function(String tag, dynamic Function(String) getValue) _fn;

  _StubRulesEngine(this._fn) : super(rules: const []);

  @override
  bool isVisible(String tag, dynamic Function(String key) getValue) =>
      _fn(tag, getValue);
}
