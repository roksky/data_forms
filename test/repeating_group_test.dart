import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:data_forms/data_forms.dart';
import 'package:data_forms/widget/fields/repeating_group_field.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Wraps [child] in the minimal Provider tree required by
/// [FormRepeatingGroupField] (which calls Provider.of<StateManager>).
Widget _buildProviderApp(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: ChangeNotifierProvider<StateManager>(
        create: (_) => StateManager(),
        child: SingleChildScrollView(child: child),
      ),
    ),
  );
}

FormRepeatingGroupField _makeGroupField({
  String tag = 'group',
  List<DataFormField>? fields,
  int? minItems,
  int? maxItems,
  String? title,
  String? addButtonText,
}) {
  final model = FormRepeatingGroupModel(
    tag: tag,
    fields: fields ?? [],
    minItems: minItems,
    maxItems: maxItems,
    title: title,
    addButtonText: addButtonText,
  );
  return FormRepeatingGroupField(model, FormStyle());
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // ==========================================================================
  // 1. FormRepeatingGroupModel — pure unit tests
  // ==========================================================================
  group('FormRepeatingGroupModel', () {
    test('stores tag, minItems, and maxItems', () {
      final model = FormRepeatingGroupModel(
        tag: 'contacts',
        fields: [],
        minItems: 2,
        maxItems: 5,
      );

      expect(model.tag, 'contacts');
      expect(model.minItems, 2);
      expect(model.maxItems, 5);
    });

    test('stores optional display text', () {
      final model = FormRepeatingGroupModel(
        tag: 'items',
        fields: [],
        addButtonText: 'Add Contact',
        removeButtonText: 'Remove Contact',
        title: 'Emergency Contact',
      );

      expect(model.addButtonText, 'Add Contact');
      expect(model.removeButtonText, 'Remove Contact');
      expect(model.title, 'Emergency Contact');
    });

    test('allowReorder defaults to true', () {
      final model = FormRepeatingGroupModel(tag: 'g', fields: []);
      expect(model.allowReorder, isTrue);
    });

    test('allowReorder can be set to false', () {
      final model = FormRepeatingGroupModel(
        tag: 'g',
        fields: [],
        allowReorder: false,
      );
      expect(model.allowReorder, isFalse);
    });

    test('copyForNewGroup appends groupId to tag', () {
      final model = FormRepeatingGroupModel(tag: 'contacts', fields: []);
      final copy = model.copyForNewGroup('abc123');

      expect(copy.tag, 'contacts_abc123');
    });

    test('copyForNewGroup preserves minItems and maxItems', () {
      final model = FormRepeatingGroupModel(
        tag: 'items',
        fields: [],
        minItems: 1,
        maxItems: 4,
      );
      final copy = model.copyForNewGroup('xyz');

      expect(copy.minItems, 1);
      expect(copy.maxItems, 4);
    });

    test('copyForNewGroup preserves allowReorder and button text', () {
      final model = FormRepeatingGroupModel(
        tag: 'items',
        fields: [],
        allowReorder: false,
        addButtonText: 'Add Row',
        removeButtonText: 'Delete',
      );
      final copy = model.copyForNewGroup('id1');

      expect(copy.allowReorder, isFalse);
      expect(copy.addButtonText, 'Add Row');
      expect(copy.removeButtonText, 'Delete');
    });

    test('copyForNewGroup updates field tags with groupId', () {
      final textField = DataFormField.text(tag: 'name');
      final model = FormRepeatingGroupModel(
        tag: 'contacts',
        fields: [textField],
      );
      model.copyForNewGroup('g1');

      // _copyFieldModel mutates the field's tag in place
      expect(textField.model!.tag, contains('g1'));
    });
  });

  // ==========================================================================
  // 2. FormRepeatingGroupField — initialization
  // ==========================================================================
  group('FormRepeatingGroupField - initialization', () {
    test('initializes groupInstances to minItems count', () {
      final field = _makeGroupField(minItems: 3);
      expect(field.groupInstances.length, 3);
    });

    test('initializes groupInstances to 1 when minItems is null', () {
      final field = _makeGroupField(minItems: null);
      expect(field.groupInstances.length, 1);
    });

    test('initializes groupInstances to 0 when minItems is 0', () {
      final field = _makeGroupField(minItems: 0);
      expect(field.groupInstances.length, 0);
    });

    test('each group instance has one slot per template field', () {
      final textField = DataFormField.text(tag: 'name');
      final model = FormRepeatingGroupModel(
        tag: 'g',
        fields: [textField],
        minItems: 2,
      );
      final field = FormRepeatingGroupField(model, FormStyle());

      expect(field.groupInstances[0].length, 1);
      expect(field.groupInstances[1].length, 1);
    });
  });

  // ==========================================================================
  // 3. FormRepeatingGroupField — group management
  // ==========================================================================
  group('FormRepeatingGroupField - group management', () {
    test('_addNewGroup increments groupInstances count', () {
      final field = _makeGroupField(minItems: 1);
      expect(field.groupInstances.length, 1);

      field.addNewGroup();
      expect(field.groupInstances.length, 2);

      field.addNewGroup();
      expect(field.groupInstances.length, 3);
    });

    test('_removeGroup decrements count when above minItems', () {
      final field = _makeGroupField(minItems: 1);
      field.addNewGroup(); // now 2 groups
      expect(field.groupInstances.length, 2);

      field.removeGroup(1);
      expect(field.groupInstances.length, 1);
    });

    test('_removeGroup removes at the given index', () {
      final field = _makeGroupField(minItems: 0);
      field.addNewGroup(); // index 0
      field.addNewGroup(); // index 1
      field.addNewGroup(); // index 2
      final thirdGroup = field.groupInstances[2];

      field.removeGroup(0);

      // The group that was at index 2 is now at index 1
      expect(field.groupInstances.length, 2);
      expect(field.groupInstances[1], thirdGroup);
    });

    test('_removeGroup does nothing when count equals minItems (null → 0)', () {
      final field = _makeGroupField(minItems: null); // minItems defaults to 1 in UI
      // minItems is null so (minItems ?? 0) == 0; a group can always be removed
      // unless groupInstances.length <= 0. With 1 group and minItems null (0):
      field.removeGroup(0);
      expect(field.groupInstances.length, 0);
    });

    test('_removeGroup enforces explicit minItems', () {
      final field = _makeGroupField(minItems: 2);
      expect(field.groupInstances.length, 2);

      // Cannot go below minItems = 2
      field.removeGroup(0);
      expect(field.groupInstances.length, 2);
    });
  });

  // ==========================================================================
  // 4. FormRepeatingGroupField — isValid()
  // ==========================================================================
  group('FormRepeatingGroupField - isValid()', () {
    test('returns true when groups satisfy minItems and no required fields', () {
      final field = _makeGroupField(minItems: 2);
      expect(field.isValid(), isTrue);
    });

    test('returns true when minItems is null and groups exist', () {
      final field = _makeGroupField(minItems: null);
      expect(field.isValid(), isTrue);
    });

    test('returns true when minItems is 0 and no groups exist', () {
      final field = _makeGroupField(minItems: 0);
      expect(field.isValid(), isTrue);
    });

    test('returns false when groupInstances.length < minItems', () {
      final field = _makeGroupField(minItems: 3);
      // Start with 3; remove one to go below minItems
      field.groupInstances.removeLast();
      expect(field.isValid(), isFalse);
    });

    test('returns false when a required field has a null value', () {
      final textField = DataFormField.text(tag: 'name', required: true);
      final model = FormRepeatingGroupModel(
        tag: 'g',
        fields: [textField],
        minItems: 1,
      );
      final field = FormRepeatingGroupField(model, FormStyle());

      // _copyFieldModel resets value to null
      expect(field.isValid(), isFalse);
    });

    test('returns false when a required field has an empty string value', () {
      final textField = DataFormField.text(tag: 'name', required: true);
      final model = FormRepeatingGroupModel(
        tag: 'g',
        fields: [textField],
        minItems: 1,
      );
      final field = FormRepeatingGroupField(model, FormStyle());

      field.groupInstances[0][0].model!.value = '';
      expect(field.isValid(), isFalse);
    });

    test('returns true when all required fields have non-empty values', () {
      final textField = DataFormField.text(tag: 'name', required: true);
      final model = FormRepeatingGroupModel(
        tag: 'g',
        fields: [textField],
        minItems: 1,
      );
      final field = FormRepeatingGroupField(model, FormStyle());

      field.groupInstances[0][0].model!.value = 'Alice';
      expect(field.isValid(), isTrue);
    });

    test('returns true for optional fields with null value', () {
      final textField = DataFormField.text(tag: 'notes', required: false);
      final model = FormRepeatingGroupModel(
        tag: 'g',
        fields: [textField],
        minItems: 1,
      );
      final field = FormRepeatingGroupField(model, FormStyle());

      // value is null but field is not required
      expect(field.isValid(), isTrue);
    });
  });

  // ==========================================================================
  // 5. FormRepeatingGroupField — getValue() (no child widgets required)
  // ==========================================================================
  group('FormRepeatingGroupField - getValue() with empty fields list', () {
    test('returns FormFieldValue with repeatingGroup type', () {
      final field = _makeGroupField(minItems: 1);
      final result = field.getValue();

      expect(result.valueType, FormFieldValueType.repeatingGroup);
    });

    test('value is a List<Map<String, dynamic>>', () {
      final field = _makeGroupField(minItems: 1);
      final result = field.getValue();

      expect(result.value, isA<List<Map<String, dynamic>>>());
    });

    test('list length matches groupInstances count', () {
      final field = _makeGroupField(minItems: 3);
      final result = field.getValue();

      expect((result.value as List).length, 3);
    });

    test('each map is empty when there are no template fields', () {
      final field = _makeGroupField(minItems: 2);
      final value = field.getValue().value as List<Map<String, dynamic>>;

      expect(value[0], isEmpty);
      expect(value[1], isEmpty);
    });

    test('returns empty list when there are no groups (minItems = 0)', () {
      final field = _makeGroupField(minItems: 0);
      final value = field.getValue().value as List<Map<String, dynamic>>;

      expect(value, isEmpty);
    });

    test('reflects added groups immediately', () {
      final field = _makeGroupField(minItems: 1);
      field.addNewGroup();
      field.addNewGroup();

      expect((field.getValue().value as List).length, 3);
    });

    test('reflects removed groups immediately', () {
      final field = _makeGroupField(minItems: 0);
      field.addNewGroup();
      field.addNewGroup();
      field.addNewGroup();
      field.removeGroup(0);

      expect((field.getValue().value as List).length, 2);
    });
  });

  // ==========================================================================
  // 6. FormFieldValue.repeatingGroup — value type
  // ==========================================================================
  group('FormFieldValue.repeatingGroup', () {
    test('creates value with repeatingGroup type', () {
      final value = FormFieldValue.repeatingGroup([]);
      expect(value.valueType, FormFieldValueType.repeatingGroup);
    });

    test('stores an empty list', () {
      final value = FormFieldValue.repeatingGroup([]);
      expect(value.value, isEmpty);
    });

    test('stores a list of maps', () {
      final data = [
        {'name': 'Alice', 'phone': '555-0001'},
        {'name': 'Bob', 'phone': '555-0002'},
      ];
      final value = FormFieldValue.repeatingGroup(data);

      expect((value.value as List).length, 2);
      expect((value.value as List<Map<String, dynamic>>)[0]['name'], 'Alice');
      expect((value.value as List<Map<String, dynamic>>)[1]['phone'], '555-0002');
    });

    test('stores nested FormFieldValue objects', () {
      final innerValue = FormFieldValue.string('test');
      final data = [
        {'field': innerValue},
      ];
      final value = FormFieldValue.repeatingGroup(data);
      final first = (value.value as List<Map<String, dynamic>>)[0];

      expect(first['field'], isA<FormFieldValue>());
    });
  });

  // ==========================================================================
  // 7. Widget rendering — add / remove button visibility
  // ==========================================================================
  group('FormRepeatingGroupField - widget rendering', () {
    testWidgets('shows add button when no maxItems set', (tester) async {
      await tester.pumpWidget(
        _buildProviderApp(_makeGroupField(minItems: 1)),
      );
      await tester.pump();

      expect(find.text('Add Item'), findsOneWidget);
    });

    testWidgets('uses custom add button text', (tester) async {
      await tester.pumpWidget(
        _buildProviderApp(
          _makeGroupField(minItems: 1, addButtonText: 'Add Contact'),
        ),
      );
      await tester.pump();

      expect(find.text('Add Contact'), findsOneWidget);
    });

    testWidgets('hides add button when maxItems is reached', (tester) async {
      await tester.pumpWidget(
        _buildProviderApp(_makeGroupField(minItems: 2, maxItems: 2)),
      );
      await tester.pump();

      expect(find.text('Add Item'), findsNothing);
    });

    testWidgets('shows add button when below maxItems', (tester) async {
      await tester.pumpWidget(
        _buildProviderApp(_makeGroupField(minItems: 1, maxItems: 3)),
      );
      await tester.pump();

      expect(find.text('Add Item'), findsOneWidget);
    });

    testWidgets('hides remove button when count equals minItems', (tester) async {
      await tester.pumpWidget(
        _buildProviderApp(_makeGroupField(minItems: 2)),
      );
      await tester.pump();

      // Count == minItems so remove button should not appear
      expect(find.byIcon(Icons.remove_circle_outline), findsNothing);
    });

    testWidgets('shows remove button when count exceeds minItems', (tester) async {
      final field = _makeGroupField(minItems: 1);
      field.addNewGroup(); // 2 groups, minItems = 1 → show remove

      await tester.pumpWidget(_buildProviderApp(field));
      await tester.pump();

      expect(find.byIcon(Icons.remove_circle_outline), findsWidgets);
    });

    testWidgets('tapping add button increases rendered group count',
        (tester) async {
      await tester.pumpWidget(
        _buildProviderApp(_makeGroupField(minItems: 1, maxItems: 5)),
      );
      await tester.pump();

      // Initially 1 card; tap add → 2 cards
      expect(find.byType(Card), findsNWidgets(1));
      await tester.tap(find.text('Add Item'));
      await tester.pump();
      expect(find.byType(Card), findsNWidgets(2));
    });

    testWidgets('tapping add button twice creates two additional groups',
        (tester) async {
      await tester.pumpWidget(
        _buildProviderApp(_makeGroupField(minItems: 1, maxItems: 5)),
      );
      await tester.pump();

      await tester.tap(find.text('Add Item'));
      await tester.pump();
      await tester.tap(find.text('Add Item'));
      await tester.pump();

      expect(find.byType(Card), findsNWidgets(3));
    });

    testWidgets('tapping remove button decreases rendered group count',
        (tester) async {
      final field = _makeGroupField(minItems: 1);
      field.addNewGroup(); // start with 2 so remove button is visible

      await tester.pumpWidget(_buildProviderApp(field));
      await tester.pump();

      expect(find.byType(Card), findsNWidgets(2));
      await tester.tap(find.byIcon(Icons.remove_circle_outline).first);
      await tester.pump();
      expect(find.byType(Card), findsNWidgets(1));
    });

    testWidgets('add button disappears after reaching maxItems', (tester) async {
      await tester.pumpWidget(
        _buildProviderApp(_makeGroupField(minItems: 1, maxItems: 2)),
      );
      await tester.pump();

      expect(find.text('Add Item'), findsOneWidget);
      await tester.tap(find.text('Add Item'));
      await tester.pump();

      // Now at maxItems (2) — add button should disappear
      expect(find.text('Add Item'), findsNothing);
    });

    testWidgets('group title is displayed in header', (tester) async {
      final field = _makeGroupField(minItems: 1, title: 'Contact');
      field.addNewGroup(); // 2 groups so remove buttons (and headers) appear

      await tester.pumpWidget(_buildProviderApp(field));
      await tester.pump();

      expect(find.textContaining('Contact'), findsWidgets);
    });
  });

  // ==========================================================================
  // 8. DataForm submission with repeating groups (widget integration)
  // ==========================================================================
  group('DataForm - submission with repeating groups', () {
    testWidgets('onSubmit includes the repeating group field key', (
      tester,
    ) async {
      late DataForm form;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                form = DataForm.singleSection(
                  context,
                  fields: [
                    DataFormField.repeatingGroup(
                      tag: 'contacts',
                      fields: [],
                      minItems: 1,
                    ),
                  ],
                );
                return form;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final data = form.onSubmit();
      expect(data.containsKey('contacts'), isTrue);
    });

    testWidgets('onSubmit returns repeatingGroup value type', (tester) async {
      late DataForm form;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                form = DataForm.singleSection(
                  context,
                  fields: [
                    DataFormField.repeatingGroup(
                      tag: 'items',
                      fields: [],
                      minItems: 1,
                    ),
                  ],
                );
                return form;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final data = form.onSubmit();
      expect(data['items']!.valueType, FormFieldValueType.repeatingGroup);
    });

    testWidgets('onSubmit list length matches initial minItems groups', (
      tester,
    ) async {
      late DataForm form;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                form = DataForm.singleSection(
                  context,
                  fields: [
                    DataFormField.repeatingGroup(
                      tag: 'rows',
                      fields: [],
                      minItems: 3,
                    ),
                  ],
                );
                return form;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final data = form.onSubmit();
      final groups = data['rows']!.value as List<Map<String, dynamic>>;
      expect(groups.length, 3);
    });

    testWidgets('onSubmit list length increases after tapping add', (
      tester,
    ) async {
      late DataForm form;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Builder(
                builder: (context) {
                  form = DataForm.singleSection(
                    context,
                    fields: [
                      DataFormField.repeatingGroup(
                        tag: 'lines',
                        fields: [],
                        minItems: 1,
                        maxItems: 5,
                      ),
                    ],
                  );
                  return form;
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Add twice
      await tester.tap(find.text('Add Item'));
      await tester.pump();
      await tester.tap(find.text('Add Item'));
      await tester.pump();

      final data = form.onSubmit();
      final groups = data['lines']!.value as List<Map<String, dynamic>>;
      expect(groups.length, 3);
    });

    testWidgets('onSubmit list length decreases after removing a group', (
      tester,
    ) async {
      late DataForm form;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Builder(
                builder: (context) {
                  form = DataForm.singleSection(
                    context,
                    fields: [
                      DataFormField.repeatingGroup(
                        tag: 'entries',
                        fields: [],
                        minItems: 1,
                        maxItems: 5,
                      ),
                    ],
                  );
                  return form;
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Add a group so we have 2 (and the remove button appears)
      await tester.tap(find.text('Add Item'));
      await tester.pump();
      expect((form.onSubmit()['entries']!.value as List).length, 2);

      // Remove one
      await tester.tap(find.byIcon(Icons.remove_circle_outline).first);
      await tester.pump();

      expect(
        (form.onSubmit()['entries']!.value as List).length,
        1,
      );
    });

    testWidgets('onSubmit contains each group as a Map', (tester) async {
      late DataForm form;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                form = DataForm.singleSection(
                  context,
                  fields: [
                    DataFormField.repeatingGroup(
                      tag: 'group',
                      fields: [],
                      minItems: 2,
                    ),
                  ],
                );
                return form;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final groups =
          form.onSubmit()['group']!.value as List<Map<String, dynamic>>;
      for (final g in groups) {
        expect(g, isA<Map<String, dynamic>>());
      }
    });

    testWidgets(
        'isValid() returns false when required field inside group is empty',
        (tester) async {
      late DataForm form;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                form = DataForm.singleSection(
                  context,
                  fields: [
                    DataFormField.repeatingGroup(
                      tag: 'info',
                      fields: [DataFormField.text(tag: 'name', required: true)],
                      minItems: 1,
                    ),
                  ],
                );
                return form;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(form.isValid(), isFalse);
    });

    testWidgets('multiple repeating group fields are all collected on submit',
        (tester) async {
      late DataForm form;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Builder(
                builder: (context) {
                  form = DataForm.singleSection(
                    context,
                    fields: [
                      DataFormField.repeatingGroup(
                        tag: 'contacts',
                        fields: [],
                        minItems: 1,
                      ),
                      DataFormField.repeatingGroup(
                        tag: 'addresses',
                        fields: [],
                        minItems: 2,
                      ),
                    ],
                  );
                  return form;
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final data = form.onSubmit();
      expect(data.containsKey('contacts'), isTrue);
      expect(data.containsKey('addresses'), isTrue);
      expect(
        (data['contacts']!.value as List).length,
        1,
      );
      expect(
        (data['addresses']!.value as List).length,
        2,
      );
    });
  });
}
