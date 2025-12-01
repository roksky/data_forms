import 'package:flutter_test/flutter_test.dart';
import 'package:data_forms/data_forms.dart';

void main() {
  test('test repeating group field model creation', () {
    final model = FormRepeatingGroupModel(
      tag: 'test_group',
      fields: [],
      minItems: 1,
      maxItems: 3,
    );

    expect(model.tag, 'test_group');
    expect(model.minItems, 1);
    expect(model.maxItems, 3);
    expect(model.fields, []);
  });
}
