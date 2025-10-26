import 'package:data_forms/core/field_callback.dart';
import 'package:flutter/material.dart';
import 'package:data_forms/core/form_style.dart';
import 'package:data_forms/enums/field_status.dart';
import 'package:data_forms/model/data_model/date_data_model.dart';
import 'package:data_forms/model/data_model/radio_data_model.dart';
import 'package:data_forms/model/data_model/spinner_data_model.dart';
import 'package:data_forms/model/fields_model/text_filed_model.dart';
import 'package:data_forms/model/fields_model/email_model.dart';
import 'package:data_forms/model/fields_model/mobile_model.dart';
import 'package:data_forms/model/fields_model/number_model.dart';
import 'package:data_forms/widget/field.dart';
import 'package:data_forms/widget/form.dart';
import 'package:data_forms/widget/section.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      locale: const Locale('en', 'US'),
      supportedLocales: const [Locale('en', 'US'), Locale('fa', 'IR')],
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        textTheme: null,
        colorScheme: null,
      ),
      darkTheme: ThemeData(brightness: Brightness.dark, colorScheme: null),
      home: MainTestPage(),
    );
  }
}

// ignore: must_be_immutable
class MainTestPage extends StatelessWidget {
  MainTestPage({super.key});

  late DataForm form;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('DataForm example'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil<dynamic>(
                      context,
                      MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) =>
                              MultiSectionForm()),
                      (route) =>
                          true, //if you want to disable back feature set to false
                    );
                  },
                  child: const Text('Multi Section form'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) =>
                                SingleSectionForm()),
                        (route) => true);
                  },
                  child: const Text('Single Section form'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) =>
                                RepeatingGroupForm()),
                        (route) => true);
                  },
                  child: const Text('Repeating Group form'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class SingleSectionForm extends StatefulWidget {
  SingleSectionForm({super.key});
  String? value;

  late FormFieldStatusEnum status;

  @override
  State<SingleSectionForm> createState() => _SingleSectionFormState();
}

class _SingleSectionFormState extends State<SingleSectionForm> {
  late DataForm form;
  int id = 0;

  @override
  void initState() {
    widget.value = 'dfhbdkfhbdasffffteryuiei577y ';
    widget.status = FormFieldStatusEnum.normal;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Single section Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: form = DataForm.singleSection(
                      style: FormStyle(
                          titleStyle: const TextStyle(
                              color: Colors.black87, fontSize: 16.0)),
                      context,
                      fields: [
                        DataFormField.email(
                          tag: 'email',
                          title: 'login',
                          weight: 12,
                          required: true,
                          maxLength: 100,
                          errorMessage: 'erro',
                          value: 'dastras.saeed@gmail.com',
                        ),
                        DataFormField.spinner(
                          tag: 'customer_type',
                          required: false,
                          weight: 12,
                          showTitle: false,
                          onChange: (model) {
                            id = model!.id;
                            setState(() {});
                          },
                          items: [
                            SpinnerDataModel(
                              name: 'm1',
                              id: 0,
                            ),
                            SpinnerDataModel(
                              name: 'm2',
                              id: 1,
                            ),
                            SpinnerDataModel(
                              name: 'm3',
                              id: 2,
                            ),
                          ],
                        ),
                        DataFormField.spinner(
                          tag: 'customer_type',
                          required: false,
                          weight: 6,
                          title: 'Gender',
                          onChange: (model) {},
                          items: [
                            SpinnerDataModel(
                                name: '3', id: 0, isSelected: id == 0),
                            SpinnerDataModel(
                              name: '4',
                              id: 1,
                              isSelected: id == 1,
                            ),
                            SpinnerDataModel(
                                name: '8', id: 2, isSelected: id == 2),
                          ],
                        ),
                      ]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        bool isValid = form.isValid();
                        Map<String, FormFieldValue> map = form.onSubmit();
                        debugPrint(map.toString());
                        debugPrint(isValid.toString());
                        setState(() {});
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class MultiSectionForm extends StatelessWidget {
  MultiSectionForm({super.key});

  late DataForm form;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multi section screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12, top: 24),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: form = DataForm.multiSection(context, sections: [
                  FormSection(sectionTitle: 'User information', fields: [
                    DataFormField.text(
                      value: 'Some text',
                      tag: 'name',
                      title: 'Name',
                      minLine: 1,
                      maxLine: 1,
                    ),
                    DataFormField.text(
                      value: 'Some text',
                      tag: 'name',
                      title: 'Name',
                      minLine: 1,
                      maxLine: 1,
                    ),
                    DataFormField.radioGroup(
                      hint: 'Radio Group',
                      tag: 'radio',
                      showScrollBar: true,
                      scrollBarColor: Colors.red,
                      scrollDirection: Axis.horizontal,
                      height: 50,
                      scrollable: true,
                      required: true,
                      weight: 12,
                      title: 'Size number',
                      searchable: false,
                      searchHint: 'Search...',
                      searchIcon: const Icon(Icons.search),
                      searchBoxDecoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      items: [
                        RadioDataModel(title: 'lorem', isSelected: false),
                        RadioDataModel(title: 'ipsum', isSelected: false),
                      ],
                      callBack: (data) {},
                    ),
                    DataFormField.datePicker(
                      tag: 'licenceExpireDate',
                      title: 'DatePicker',
                      weight: 12,
                      required: false,
                      initialDate: DataDate(day: 10, month: 5, year: 2023),
                      errorMessage: 'please enter a name',
                    ),
                    DataFormField.text(
                      value: 'Pauline',
                      tag: 'lastName',
                      title: 'Last name',
                      minLine: 1,
                      maxLine: 1,
                      weight: 12,
                      required: true,
                    ),
                    DataFormField.spinner(
                      tag: 'customer_type',
                      required: false,
                      weight: 6,
                      title: 'Gender',
                      value: SpinnerDataModel(
                        name: 'woman',
                        id: 2,
                      ),
                      onChange: (model) {},
                      items: [
                        SpinnerDataModel(
                          name: 'man',
                          id: 1,
                        ),
                        SpinnerDataModel(
                          name: 'woman',
                          id: 2,
                        ),
                        SpinnerDataModel(
                          name: 'woman',
                          id: 2,
                        ),
                      ],
                    ),
                    DataFormField.mobile(
                      tag: 'mobile',
                      title: 'Phone number',
                      maxLength: 11,
                      helpMessage: '9357814747',
                      weight: 6,
                      required: false,
                      errorMessage: 'some error',
                    ),
                  ]),
                  FormSection(
                    sectionTitle: 'Market information',
                    fields: [
                      DataFormField.text(
                        tag: 'name',
                        title: 'Market name',
                        minLine: 1,
                        maxLine: 1,
                        weight: 12,
                        required: false,
                        errorMessage: 'please enter a name',
                      ),
                      DataFormField.textPlain(
                        hint: 'sds',
                        tag: 'lastName',
                        title: 'Market address',
                        maxLine: 4,
                        maxLength: 233,
                        showCounter: false,
                        weight: 12,
                        prefixWidget:
                            const Icon(Icons.location_city, color: Colors.blue),
                        required: true,
                      ),
                      DataFormField.spinner(
                        tag: 'customer_type',
                        required: false,
                        weight: 6,
                        title: 'Market type',
                        items: [
                          SpinnerDataModel(
                            name: 'Super market',
                            id: 1,
                          ),
                          SpinnerDataModel(
                            name: 'woman',
                            id: 2,
                          ),
                        ],
                      ),
                      DataFormField.mobile(
                        tag: 'mobile',
                        title: 'Telephone',
                        maxLength: 11,
                        helpMessage: '9357814747',
                        weight: 6,
                        required: false,
                        errorMessage: 'some error',
                      ),
                      DataFormField.integer(
                        tag: 'integer_field',
                        title: 'Integer Field',
                        weight: 6,
                        required: true,
                        errorMessage: 'Please enter a valid integer',
                      ),
                      DataFormField.double(
                        tag: 'double_field',
                        title: 'Double Field',
                        weight: 6,
                        required: true,
                        errorMessage: 'Please enter a valid double',
                      ),
                      DataFormField.qrScanner(
                        tag: 'qr_scanner',
                        title: 'QR Scanner',
                        weight: 6,
                        required: true,
                        errorMessage: 'Please scan a valid QR code',
                      ),
                      DataFormField.filePicker(
                        tag: 'file_picker',
                        title: 'File Picker',
                        weight: 6,
                        required: true,
                        errorMessage: 'Please select a file',
                      ),
                      DataFormField.multiMediaPicker(
                        tag: 'multi_media_picker',
                        title: 'Multi Media Picker',
                        weight: 6,
                        required: true,
                        errorMessage: 'Please select media files',
                      ),
                      DataFormField.signature(
                        tag: 'signature',
                        title: 'Signature',
                        weight: 6,
                        required: true,
                        errorMessage: 'Please provide a signature',
                      ),
                      DataFormField.barcode(
                        tag: 'barcode',
                        title: 'Barcode Scanner',
                        weight: 6,
                        required: true,
                        errorMessage: 'Please scan a valid barcode',
                      ),
                      DataFormField.boolSwitch(
                        tag: 'boolean',
                        title: 'Boolean Switch',
                        weight: 6,
                        required: true,
                        errorMessage: 'Please select a boolean value',
                      ),
                      DataFormField.locationTree(
                        tag: 'location_tree',
                        title: 'Location Tree',
                        weight: 6,
                        required: true,
                        errorMessage: 'Please select a location',
                        fetchLocations: (String? parentId) {
                          return Future.value([]);
                        },
                        fetchLocationById: (String locationId) {
                          return Future.value(null);
                        },
                      ),
                    ],
                  ),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        bool isValid = form.isValid();
                        Map<String, FormFieldValue> map = form.onSubmit();
                        debugPrint(isValid.toString());
                        debugPrint(map.toString());
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class RepeatingGroupForm extends StatelessWidget {
  RepeatingGroupForm({super.key});

  late DataForm form;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Repeating Group Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12, top: 24),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: form = DataForm.multiSection(context, sections: [
                  FormSection(
                    sectionTitle: 'Contact Information',
                    fields: [
                      DataFormField.repeatingGroup(
                        tag: 'contacts',
                        title: 'Emergency Contacts',
                        showTitle: true,
                        minItems: 1,
                        maxItems: 5,
                        addButtonText: 'Add Contact',
                        removeButtonText: 'Remove',
                        required: true,
                        fields: [
                          DataFormField.text(
                            tag: 'contact_name',
                            title: 'Contact Name',
                            required: true,
                            weight: 12,
                          ),
                          DataFormField.email(
                            tag: 'contact_email',
                            title: 'Email Address',
                            required: false,
                            weight: 12,
                          ),
                          DataFormField.mobile(
                            tag: 'contact_phone',
                            title: 'Phone Number',
                            required: true,
                            weight: 12,
                          ),
                          DataFormField.text(
                            tag: 'relationship',
                            title: 'Relationship',
                            required: false,
                            weight: 12,
                          ),
                        ],
                      ),
                    ],
                  ),
                  FormSection(
                    sectionTitle: 'Work Experience',
                    fields: [
                      DataFormField.repeatingGroup(
                        tag: 'work_experience',
                        title: 'Previous Jobs',
                        showTitle: true,
                        minItems: 0,
                        maxItems: 10,
                        addButtonText: 'Add Job Experience',
                        removeButtonText: 'Remove Job',
                        required: false,
                        fields: [
                          DataFormField.text(
                            tag: 'company_name',
                            title: 'Company Name',
                            required: true,
                            weight: 12,
                          ),
                          DataFormField.text(
                            tag: 'job_title',
                            title: 'Job Title',
                            required: true,
                            weight: 12,
                          ),
                          DataFormField.integer(
                            tag: 'years_worked',
                            title: 'Years Worked',
                            required: false,
                            weight: 6,
                          ),
                          DataFormField.text(
                            tag: 'job_description',
                            title: 'Job Description',
                            required: false,
                            weight: 12,
                          ),
                        ],
                      ),
                    ],
                  ),
                  FormSection(
                    sectionTitle: 'Weigh',
                    fields: [
                      DataFormField.repeatingGroup(
                        tag: 'animal_weights',
                        title: 'New Weights',
                        showTitle: true,
                        minItems: 0,
                        maxItems: 10,
                        addButtonText: 'Record Weight',
                        removeButtonText: 'Remove Weight',
                        required: false,
                        fields: [
                          DataFormField.text(
                            tag: 'tag_number',
                            title: 'Tag Number',
                            required: true,
                            weight: 6,
                          ),
                          DataFormField.integer(
                            tag: 'weight',
                            title: 'Weight',
                            required: false,
                            weight: 6,
                          ),
                        ],
                      ),
                    ],
                  ),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        bool isValid = form.isValid();
                        Map<String, FormFieldValue> map = form.onSubmit();
                        debugPrint('Form is valid: $isValid');
                        debugPrint('Form values: $map');
                        
                        // Show validation result to user
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(isValid 
                              ? 'Form submitted successfully!' 
                              : 'Please check required fields'),
                            backgroundColor: isValid ? Colors.green : Colors.red,
                          ),
                        );
                      },
                      child: const Text('Submit Form'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
