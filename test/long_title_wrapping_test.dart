import 'package:data_forms/data_forms.dart';
import 'package:data_forms/enums/required_check_list_enum.dart';
import 'package:data_forms/model/data_model/check_data_model.dart';
import 'package:data_forms/model/data_model/location_item_model.dart';
import 'package:data_forms/model/data_model/radio_data_model.dart';
import 'package:data_forms/model/data_model/spinner_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

const _longTitle =
    'This is a deliberately long field title that must wrap cleanly on a '
    'narrow mobile viewport without clipping, ellipsis, overlap, or overflow';

const _longOption =
    'This is a deliberately long option label that should wrap beside its '
    'selection control while the control remains aligned with the first line';

Widget _wrap(Widget child) {
  return MaterialApp(
    home: ChangeNotifierProvider<StateManager>(
      create: (_) => StateManager(),
      child: Scaffold(body: SingleChildScrollView(child: child)),
    ),
  );
}

Future<List<FlutterErrorDetails>> _pumpAndCollectFlutterErrors(
  WidgetTester tester,
  Widget widget,
) async {
  final previousOnError = FlutterError.onError;
  final errors = <FlutterErrorDetails>[];
  FlutterError.onError = errors.add;
  addTearDown(() => FlutterError.onError = previousOnError);

  await tester.pumpWidget(widget);
  await tester.pump();

  return errors;
}

Matcher _hasNoRenderOverflowErrors() {
  return isNot(
    contains(
      predicate<FlutterErrorDetails>(
        (details) =>
            details.exceptionAsString().contains('RenderFlex overflowed') ||
            details.toString().contains('A RenderFlex overflowed'),
      ),
    ),
  );
}

List<DataFormField> _allLongTitleFields() {
  return [
    DataFormField.qrScanner(
      tag: 'qr',
      title: _longTitle,
      showTitle: true,
      required: true,
      hint: _longOption,
    ),
    DataFormField.imagePicker(
      tag: 'image',
      iconWidget: const Icon(Icons.image),
      title: _longTitle,
      showTitle: true,
      required: true,
      hint: _longOption,
      showCropper: false,
    ),
    DataFormField.multiImagePicker(
      tag: 'multi_image',
      iconWidget: const Icon(Icons.collections),
      title: _longTitle,
      showTitle: true,
      required: true,
      hint: _longOption,
      showCropper: false,
    ),
    DataFormField.spinner(
      tag: 'spinner',
      title: _longTitle,
      showTitle: true,
      required: true,
      hint: _longOption,
      items: [SpinnerDataModel(id: 1, name: _longOption, isSelected: true)],
    ),
    DataFormField.radioGroup(
      tag: 'radio',
      title: _longTitle,
      showTitle: true,
      required: true,
      searchable: false,
      scrollable: true,
      height: 120,
      items: [
        RadioDataModel(title: _longOption, isSelected: false),
        RadioDataModel(title: 'Short option', isSelected: false),
      ],
      callBack: (_) {},
    ),
    DataFormField.checkList(
      tag: 'checklist',
      title: _longTitle,
      showTitle: true,
      searchable: false,
      scrollable: true,
      height: 120,
      requiredCheckListEnum: RequiredCheckListEnum.atLeastOneItem,
      items: [
        CheckDataModel(title: _longOption, isSelected: false),
        CheckDataModel(title: 'Short option', isSelected: false),
      ],
      callBack: (_) {},
    ),
    DataFormField.text(
      tag: 'text',
      title: _longTitle,
      showTitle: true,
      required: true,
      hint: _longOption,
    ),
    DataFormField.password(
      tag: 'password',
      title: _longTitle,
      showTitle: true,
      required: true,
      hint: _longOption,
    ),
    DataFormField.textPlain(
      tag: 'plain',
      title: _longTitle,
      showTitle: true,
      required: true,
      hint: _longOption,
      minLine: 1,
      maxLine: 2,
    ),
    DataFormField.mobile(
      tag: 'mobile',
      title: _longTitle,
      showTitle: true,
      required: true,
      hint: _longOption,
    ),
    DataFormField.number(
      tag: 'number',
      title: _longTitle,
      showTitle: true,
      required: true,
      hint: _longOption,
    ),
    DataFormField.integer(
      tag: 'integer',
      title: _longTitle,
      showTitle: true,
      required: true,
      hint: _longOption,
    ),
    DataFormField.double(
      tag: 'double',
      title: _longTitle,
      showTitle: true,
      required: true,
      hint: _longOption,
    ),
    DataFormField.datePicker(
      tag: 'date',
      title: _longTitle,
      showTitle: true,
      required: true,
      hint: _longOption,
    ),
    DataFormField.dateRangePicker(
      tag: 'date_range',
      title: _longTitle,
      showTitle: true,
      required: true,
      hint: _longOption,
      from: 'Very long from label',
      to: 'Very long to label',
    ),
    DataFormField.time(
      tag: 'time',
      title: _longTitle,
      showTitle: true,
      required: true,
      hint: _longOption,
    ),
    DataFormField.email(
      tag: 'email',
      title: _longTitle,
      showTitle: true,
      required: true,
      hint: _longOption,
    ),
    DataFormField.price(
      tag: 'price',
      title: _longTitle,
      showTitle: true,
      required: true,
      hint: _longOption,
      currencyName: 'USD',
    ),
    DataFormField.bankCard(
      tag: 'bank_card',
      title: _longTitle,
      showTitle: true,
      required: true,
      hint: _longOption,
    ),
    DataFormField.filePicker(
      tag: 'file',
      title: _longTitle,
      showTitle: true,
      required: true,
      hint: _longOption,
    ),
    DataFormField.multiMediaPicker(
      tag: 'media',
      title: _longTitle,
      showTitle: true,
      required: true,
    ),
    DataFormField.signature(
      tag: 'signature',
      title: _longTitle,
      showTitle: true,
      required: true,
      hint: _longOption,
      iconWidget: const Icon(Icons.draw),
    ),
    DataFormField.barcode(
      tag: 'barcode',
      title: _longTitle,
      showTitle: true,
      required: true,
    ),
    DataFormField.locationTree(
      tag: 'location_tree',
      title: _longTitle,
      showTitle: true,
      required: true,
      fetchLocations:
          (_) async => [
            LocationItem(id: 'city', name: _longOption, level: 'city'),
          ],
      fetchLocationById:
          (_) async => LocationItem(id: 'city', name: _longOption),
    ),
    DataFormField.location(
      tag: 'location',
      title: _longTitle,
      showTitle: true,
      required: true,
    ),
    DataFormField.boolSwitch(
      tag: 'bool',
      title: _longTitle,
      showTitle: true,
      required: true,
    ),
    DataFormField.colorPicker(
      tag: 'color',
      title: _longTitle,
      showTitle: true,
      required: true,
      value: '#336699',
    ),
    DataFormField.repeatingGroup(
      tag: 'repeating',
      title: _longTitle,
      showTitle: true,
      minItems: 1,
      fields: [
        DataFormField.text(
          tag: 'nested_text',
          title: _longTitle,
          showTitle: true,
          hint: _longOption,
        ),
      ],
    ),
  ];
}

void main() {
  setUp(() {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.single;
    view.physicalSize = const Size(320, 1600);
    view.devicePixelRatio = 1.0;
  });

  tearDown(() {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.single;
    view.resetPhysicalSize();
    view.resetDevicePixelRatio();
  });

  testWidgets('long titles render for every public DataFormField constructor', (
    tester,
  ) async {
    final errors = await _pumpAndCollectFlutterErrors(
      tester,
      _wrap(
        FormSection(sectionTitle: _longTitle, fields: _allLongTitleFields()),
      ),
    );

    expect(errors, _hasNoRenderOverflowErrors());
  });

  testWidgets('weighted fields with long titles do not overflow in one row', (
    tester,
  ) async {
    final errors = await _pumpAndCollectFlutterErrors(
      tester,
      _wrap(
        FormSection(
          sectionTitle: _longTitle,
          fields: [
            DataFormField.text(
              tag: 'first',
              title: _longTitle,
              showTitle: true,
              required: true,
              weight: 6,
            ),
            DataFormField.text(
              tag: 'second',
              title: _longTitle,
              showTitle: true,
              required: true,
              weight: 6,
            ),
          ],
        ),
      ),
    );

    expect(errors, _hasNoRenderOverflowErrors());
  });
}
