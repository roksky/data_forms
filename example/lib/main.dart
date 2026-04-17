import 'package:data_forms/core/field_callback.dart';
import 'package:flutter/material.dart';
import 'package:data_forms/core/form_style.dart';
import 'package:data_forms/enums/field_status.dart';
import 'package:data_forms/enums/required_check_list_enum.dart';
import 'package:data_forms/model/data_model/check_data_model.dart';
import 'package:data_forms/model/data_model/date_data_model.dart';
import 'package:data_forms/model/data_model/location_item_model.dart';
import 'package:data_forms/model/data_model/radio_data_model.dart';
import 'package:data_forms/model/data_model/spinner_data_model.dart';
import 'package:data_forms/rules/form_rule.dart';
import 'package:data_forms/widget/field.dart';
import 'package:data_forms/widget/form.dart';
import 'package:data_forms/widget/section.dart';

void main() {
  runApp(const MyApp());
}

class _DemoColors {
  static const ink = Color(0xFF17211D);
  static const muted = Color(0xFF66716C);
  static const surface = Color(0xFFFFFFFF);
  static const background = Color(0xFFF4F7F5);
  static const primary = Color(0xFF16785C);
  static const primaryDark = Color(0xFF0D4F3C);
  static const accent = Color(0xFFCB6B32);
  static const border = Color(0xFFDCE5E0);
}

ThemeData _buildDemoTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: _DemoColors.primary,
    brightness: Brightness.light,
    primary: _DemoColors.primary,
    secondary: _DemoColors.accent,
    surface: _DemoColors.surface,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: _DemoColors.background,
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: _DemoColors.background,
      foregroundColor: _DemoColors.ink,
      titleTextStyle: TextStyle(
        color: _DemoColors.ink,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _DemoColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size.fromHeight(48),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    ),
    cardTheme: CardThemeData(
      color: _DemoColors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: _DemoColors.border),
      ),
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        color: _DemoColors.ink,
        fontSize: 28,
        fontWeight: FontWeight.w800,
        height: 1.15,
      ),
      titleLarge: TextStyle(
        color: _DemoColors.ink,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: TextStyle(color: _DemoColors.ink, fontSize: 16, height: 1.45),
      bodyMedium: TextStyle(
        color: _DemoColors.muted,
        fontSize: 14,
        height: 1.35,
      ),
    ),
  );
}

FormStyle _sampleFormStyle() {
  return FormStyle(
    backgroundFieldColor: Colors.white,
    backgroundSectionColor: Colors.white,
    fieldBorderColor: _DemoColors.border,
    sectionCardElevation: 0,
    sectionCardPadding: 16,
    sectionRadius: 8,
    fieldRadius: 8,
    titleStyle: const TextStyle(
      color: _DemoColors.ink,
      fontSize: 14,
      fontWeight: FontWeight.w700,
    ),
    fieldTextStyle: const TextStyle(color: _DemoColors.ink, fontSize: 15),
    fieldHintStyle: const TextStyle(color: _DemoColors.muted, fontSize: 14),
    helpTextStyle: const TextStyle(color: _DemoColors.muted, fontSize: 12),
    errorTextStyle: const TextStyle(
      color: Color(0xFFC62828),
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
    sectionTitleStyle: const TextStyle(
      color: _DemoColors.primaryDark,
      fontSize: 18,
      fontWeight: FontWeight.w800,
    ),
  );
}

class _PageInsets {
  static EdgeInsets content(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontal = width >= 900 ? (width - 840) / 2 : 16.0;
    return EdgeInsets.fromLTRB(horizontal, 12, horizontal, 16);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Forms Demo',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      locale: const Locale('en', 'US'),
      supportedLocales: const [Locale('en', 'US'), Locale('fa', 'IR')],
      theme: _buildDemoTheme(),
      darkTheme: ThemeData(brightness: Brightness.dark),
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
    final cards = [
      _DemoFormCard(
        icon: Icons.dashboard_customize_outlined,
        title: 'Multi-section form',
        description:
            'A longer intake flow with grouped customer and market data.',
        onTap: () => _open(context, MultiSectionForm()),
      ),
      _DemoFormCard(
        icon: Icons.view_list_outlined,
        title: 'All field types',
        description: 'Searchable gallery with every available field widget.',
        onTap: () => _open(context, AllFieldTypesForm()),
      ),
      _DemoFormCard(
        icon: Icons.article_outlined,
        title: 'Single-section form',
        description:
            'A compact form with validation, values, and field changes.',
        onTap: () => _open(context, SingleSectionForm()),
      ),
      _DemoFormCard(
        icon: Icons.playlist_add_outlined,
        title: 'Repeating groups',
        description: 'Dynamic contact, work history, and weight entries.',
        onTap: () => _open(context, RepeatingGroupForm()),
      ),
      _DemoFormCard(
        icon: Icons.account_tree_outlined,
        title: 'Rules engine',
        description: 'Sections and fields that react to previous answers.',
        onTap: () => _open(context, RulesEngineForm()),
      ),
      _DemoFormCard(
        icon: Icons.rule_folder_outlined,
        title: 'Section rulesJson',
        description: 'Constructor-level JSON rules for conditional screens.',
        onTap: () => _open(context, SectionRulesJsonForm()),
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: _PageInsets.content(context),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 12),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: _DemoColors.primaryDark,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: .12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Data Forms',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            'Choose a sample form',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              height: 1.1,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Explore validation, dynamic sections, repeating groups, and JSON-driven rules in focused examples.',
                            style: TextStyle(
                              color: Color(0xFFE7F2EE),
                              fontSize: 15,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                ]),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                _PageInsets.content(context).left,
                0,
                _PageInsets.content(context).right,
                24,
              ),
              sliver: SliverGrid.builder(
                itemCount: cards.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      MediaQuery.sizeOf(context).width >= 720 ? 2 : 1,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  mainAxisExtent: 132,
                ),
                itemBuilder: (context, index) => cards[index],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _open(BuildContext context, Widget page) {
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(builder: (BuildContext context) => page),
    );
  }
}

class _DemoFormCard extends StatelessWidget {
  const _DemoFormCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF4F0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: _DemoColors.primaryDark),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward, color: _DemoColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldTypeSample {
  const _FieldTypeSample({
    required this.type,
    required this.section,
    required this.builder,
  });

  final String type;
  final String section;
  final DataFormField Function() builder;

  bool matches(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return true;
    }
    return type.toLowerCase().contains(normalized) ||
        section.toLowerCase().contains(normalized);
  }
}

// ignore: must_be_immutable
class AllFieldTypesForm extends StatefulWidget {
  const AllFieldTypesForm({super.key});

  @override
  State<AllFieldTypesForm> createState() => _AllFieldTypesFormState();
}

class _AllFieldTypesFormState extends State<AllFieldTypesForm> {
  DataForm? form;
  final TextEditingController searchController = TextEditingController();
  String query = '';

  List<_FieldTypeSample> get _samples {
    return [
      _FieldTypeSample(
        type: 'text',
        section: 'Text and numbers',
        builder: () => DataFormField.text(
          tag: 'sample_text',
          title: 'Text field (text)',
          hint: 'Single line text',
          value: 'Sample text',
          weight: 12,
        ),
      ),
      _FieldTypeSample(
        type: 'textPlain',
        section: 'Text and numbers',
        builder: () => DataFormField.textPlain(
          tag: 'sample_text_plain',
          title: 'Plain text field (textPlain)',
          hint: 'Multiple lines',
          value: 'Plain text value',
          maxLine: 3,
          weight: 12,
        ),
      ),
      _FieldTypeSample(
        type: 'password',
        section: 'Text and numbers',
        builder: () => DataFormField.password(
          tag: 'sample_password',
          title: 'Password field (password)',
          hint: 'Password',
          value: 'secret123',
          weight: 6,
        ),
      ),
      _FieldTypeSample(
        type: 'email',
        section: 'Text and numbers',
        builder: () => DataFormField.email(
          tag: 'sample_email',
          title: 'Email field (email)',
          hint: 'name@example.com',
          value: 'demo@example.com',
          weight: 6,
        ),
      ),
      _FieldTypeSample(
        type: 'mobile',
        section: 'Text and numbers',
        builder: () => DataFormField.mobile(
          tag: 'sample_mobile',
          title: 'Mobile field (mobile)',
          hint: 'Phone number',
          value: '5551234567',
          weight: 6,
        ),
      ),
      _FieldTypeSample(
        type: 'number',
        section: 'Text and numbers',
        builder: () => DataFormField.number(
          tag: 'sample_number',
          title: 'Number field (number)',
          hint: 'Any number',
          value: '42',
          weight: 6,
        ),
      ),
      _FieldTypeSample(
        type: 'integer',
        section: 'Text and numbers',
        builder: () => DataFormField.integer(
          tag: 'sample_integer',
          title: 'Integer field (integer)',
          hint: 'Whole number',
          value: 7,
          weight: 6,
        ),
      ),
      _FieldTypeSample(
        type: 'double',
        section: 'Text and numbers',
        builder: () => DataFormField.double(
          tag: 'sample_double',
          title: 'Double field (double)',
          hint: 'Decimal number',
          value: 12.5,
          weight: 6,
        ),
      ),
      _FieldTypeSample(
        type: 'price',
        section: 'Text and numbers',
        builder: () => DataFormField.price(
          tag: 'sample_price',
          title: 'Price field (price)',
          hint: 'Amount',
          value: 99.95,
          currencyName: 'USD',
          weight: 6,
        ),
      ),
      _FieldTypeSample(
        type: 'bankCard',
        section: 'Text and numbers',
        builder: () => DataFormField.bankCard(
          tag: 'sample_bank_card',
          title: 'Bank card field (bankCard)',
          hint: 'Card number',
          value: '4242424242424242',
          weight: 6,
        ),
      ),
      _FieldTypeSample(
        type: 'spinner',
        section: 'Choices and dates',
        builder: () => DataFormField.spinner(
          tag: 'sample_spinner',
          title: 'Spinner field (spinner)',
          hint: 'Select an option',
          value: SpinnerDataModel(name: 'Second option', id: 2),
          items: [
            SpinnerDataModel(name: 'First option', id: 1),
            SpinnerDataModel(name: 'Second option', id: 2),
            SpinnerDataModel(name: 'Third option', id: 3),
          ],
          onChange: (_) {},
          weight: 6,
        ),
      ),
      _FieldTypeSample(
        type: 'radioGroup',
        section: 'Choices and dates',
        builder: () => DataFormField.radioGroup(
          tag: 'sample_radio_group',
          title: 'Radio group field (radioGroup)',
          searchable: true,
          searchHint: 'Search radio choices',
          searchIcon: const Icon(Icons.search),
          items: [
            RadioDataModel(title: 'Radio first', isSelected: true),
            RadioDataModel(title: 'Radio second', isSelected: false),
            RadioDataModel(title: 'Radio third', isSelected: false),
          ],
          callBack: (_) {},
          weight: 6,
        ),
      ),
      _FieldTypeSample(
        type: 'checkList',
        section: 'Choices and dates',
        builder: () => DataFormField.checkList(
          tag: 'sample_check_list',
          title: 'Checklist field (checkList)',
          searchable: true,
          searchHint: 'Search checklist choices',
          requiredCheckListEnum: RequiredCheckListEnum.atLeastOneItem,
          items: [
            CheckDataModel(title: 'Checklist first', isSelected: true),
            CheckDataModel(title: 'Checklist second', isSelected: false),
            CheckDataModel(title: 'Checklist third', isSelected: false),
          ],
          callBack: (_) {},
          weight: 12,
        ),
      ),
      _FieldTypeSample(
        type: 'date',
        section: 'Choices and dates',
        builder: () => DataFormField.datePicker(
          tag: 'sample_date',
          title: 'Date picker field (date)',
          initialDate: DataDate(year: 2026, month: 4, day: 17),
          displayDateType: GSDateFormatType.numeric,
          weight: 6,
        ),
      ),
      _FieldTypeSample(
        type: 'dateRage',
        section: 'Choices and dates',
        builder: () => DataFormField.dateRangePicker(
          tag: 'sample_date_range',
          title: 'Date range picker field (dateRage)',
          initialStartDate: DataDate(year: 2026, month: 4, day: 17),
          initialEndDate: DataDate(year: 2026, month: 4, day: 24),
          displayDateType: GSDateFormatType.numeric,
          weight: 6,
        ),
      ),
      _FieldTypeSample(
        type: 'time',
        section: 'Choices and dates',
        builder: () => DataFormField.time(
          tag: 'sample_time',
          title: 'Time picker field (time)',
          initialTime: const TimeOfDay(hour: 9, minute: 30),
          weight: 6,
        ),
      ),
      _FieldTypeSample(
        type: 'boolean',
        section: 'Choices and dates',
        builder: () => DataFormField.boolSwitch(
          tag: 'sample_boolean',
          title: 'Boolean switch field (boolean)',
          value: true,
          weight: 6,
        ),
      ),
      _FieldTypeSample(
        type: 'imagePicker',
        section: 'Files, media, and scanners',
        builder: () => DataFormField.imagePicker(
          tag: 'sample_image_picker',
          title: 'Image picker field (imagePicker)',
          hint: 'Pick or capture an image',
          iconWidget: const Icon(Icons.image_outlined),
          showCropper: false,
          weight: 6,
        ),
      ),
      _FieldTypeSample(
        type: 'multiImagePicker',
        section: 'Files, media, and scanners',
        builder: () => DataFormField.multiImagePicker(
          tag: 'sample_multi_image_picker',
          title: 'Multi image picker field (multiImagePicker)',
          hint: 'Pick multiple images',
          iconWidget: const Icon(Icons.photo_library_outlined),
          showCropper: false,
          maximumImageCount: 4,
          weight: 6,
        ),
      ),
      _FieldTypeSample(
        type: 'filePicker',
        section: 'Files, media, and scanners',
        builder: () => DataFormField.filePicker(
          tag: 'sample_file_picker',
          title: 'File picker field (filePicker)',
          hint: 'Select one or more files',
          allowMultiple: true,
          weight: 6,
        ),
      ),
      _FieldTypeSample(
        type: 'multiMediaPicker',
        section: 'Files, media, and scanners',
        builder: () => DataFormField.multiMediaPicker(
          tag: 'sample_multi_media_picker',
          title: 'Multi media picker field (multiMediaPicker)',
          helpMessage: 'Images and videos',
          weight: 6,
        ),
      ),
      _FieldTypeSample(
        type: 'qrScanner',
        section: 'Files, media, and scanners',
        builder: () => DataFormField.qrScanner(
          tag: 'sample_qr_scanner',
          title: 'QR scanner field (qrScanner)',
          hint: 'Scan a QR code',
          iconWidget: const Icon(Icons.qr_code_scanner_outlined),
          weight: 6,
        ),
      ),
      _FieldTypeSample(
        type: 'barcode',
        section: 'Files, media, and scanners',
        builder: () => DataFormField.barcode(
          tag: 'sample_barcode',
          title: 'Barcode scanner field (barcode)',
          helpMessage: 'Scan a barcode',
          weight: 6,
        ),
      ),
      _FieldTypeSample(
        type: 'signature',
        section: 'Files, media, and scanners',
        builder: () => DataFormField.signature(
          tag: 'sample_signature',
          title: 'Signature field (signature)',
          hint: 'Capture a signature',
          iconWidget: const Icon(Icons.draw_outlined),
          weight: 6,
        ),
      ),
      _FieldTypeSample(
        type: 'location',
        section: 'Location and advanced',
        builder: () => DataFormField.location(
          tag: 'sample_location',
          title: 'Location field (location)',
          helpMessage: 'Uses device location when available',
          weight: 6,
        ),
      ),
      _FieldTypeSample(
        type: 'locationTree',
        section: 'Location and advanced',
        builder: () => DataFormField.locationTree(
          tag: 'sample_location_tree',
          title: 'Location tree field (locationTree)',
          hint: 'Pick a nested location',
          targetLevel: 'city',
          fetchLocations: _fetchSampleLocations,
          fetchLocationById: _fetchSampleLocationById,
          weight: 6,
        ),
      ),
      _FieldTypeSample(
        type: 'colorPicker',
        section: 'Location and advanced',
        builder: () => DataFormField.colorPicker(
          tag: 'sample_color_picker',
          title: 'Color picker field (colorPicker)',
          value: '#16785C',
          colors: const [
            Color(0xFF16785C),
            Color(0xFFCB6B32),
            Color(0xFF2D6CDF),
            Color(0xFFC62828),
          ],
          weight: 6,
        ),
      ),
      _FieldTypeSample(
        type: 'repeatingGroup',
        section: 'Location and advanced',
        builder: () => DataFormField.repeatingGroup(
          tag: 'sample_repeating_group',
          title: 'Repeating group field (repeatingGroup)',
          addButtonText: 'Add row',
          removeButtonText: 'Remove row',
          minItems: 1,
          maxItems: 3,
          fields: [
            DataFormField.text(
              tag: 'sample_group_name',
              title: 'Nested text field',
              weight: 6,
            ),
            DataFormField.integer(
              tag: 'sample_group_quantity',
              title: 'Nested integer field',
              weight: 6,
            ),
          ],
          weight: 12,
        ),
      ),
    ];
  }

  static Future<List<LocationItem>> _fetchSampleLocations(String? parentId) {
    if (parentId == null) {
      return Future.value([
        LocationItem(id: 'kenya', name: 'Kenya', level: 'country'),
        LocationItem(id: 'usa', name: 'United States', level: 'country'),
      ]);
    }
    if (parentId == 'kenya') {
      return Future.value([
        LocationItem(id: 'nairobi', name: 'Nairobi', level: 'city'),
        LocationItem(id: 'mombasa', name: 'Mombasa', level: 'city'),
      ]);
    }
    if (parentId == 'usa') {
      return Future.value([
        LocationItem(id: 'new_york', name: 'New York', level: 'city'),
        LocationItem(id: 'seattle', name: 'Seattle', level: 'city'),
      ]);
    }
    return Future.value([]);
  }

  static Future<LocationItem?> _fetchSampleLocationById(String locationId) {
    final locations = <String, LocationItem>{
      'kenya': LocationItem(id: 'kenya', name: 'Kenya', level: 'country'),
      'usa': LocationItem(id: 'usa', name: 'United States', level: 'country'),
      'nairobi': LocationItem(id: 'nairobi', name: 'Nairobi', level: 'city'),
      'mombasa': LocationItem(id: 'mombasa', name: 'Mombasa', level: 'city'),
      'new_york': LocationItem(id: 'new_york', name: 'New York', level: 'city'),
      'seattle': LocationItem(id: 'seattle', name: 'Seattle', level: 'city'),
    };
    return Future.value(locations[locationId]);
  }

  List<FormSection> _buildSections(List<_FieldTypeSample> samples) {
    final grouped = <String, List<DataFormField>>{};
    for (final sample in samples) {
      grouped.putIfAbsent(sample.section, () => []).add(sample.builder());
    }
    return grouped.entries
        .map(
          (entry) => FormSection(
            sectionTitle: entry.key,
            fields: entry.value,
          ),
        )
        .toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredSamples =
        _samples.where((sample) => sample.matches(query)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('All field types')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          searchController.clear();
                          setState(() => query = '');
                        },
                      ),
                hintText: 'Search fields by type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: _DemoColors.border),
                ),
              ),
              onChanged: (value) => setState(() => query = value),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${filteredSamples.length} of ${_samples.length} field types',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: filteredSamples.isEmpty
                  ? Center(
                      child: Text(
                        'No field types match "$query".',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                  : SingleChildScrollView(
                      child: form = DataForm.multiSection(
                        context,
                        style: _sampleFormStyle(),
                        sections: _buildSections(filteredSamples),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: filteredSamples.isEmpty
                    ? null
                    : () {
                        final currentForm = form;
                        if (currentForm == null) {
                          return;
                        }
                        final isValid = currentForm.isValid();
                        final values = currentForm.onSubmit();
                        debugPrint('All field types valid: $isValid');
                        debugPrint('All field type values: $values');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isValid
                                  ? 'Submitted ${values.length} field value(s).'
                                  : 'Please check the highlighted fields.',
                            ),
                            backgroundColor:
                                isValid ? Colors.green : Colors.red,
                          ),
                        );
                      },
                child: const Text('Submit visible fields'),
              ),
            ),
          ],
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
        padding: const EdgeInsets.only(left: 12.0, right: 12, top: 24),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: form = DataForm.singleSection(
                      style: _sampleFormStyle(),
                      context,
                      fields: [
                        DataFormField.email(
                          tag: 'email',
                          title: 'Email address',
                          weight: 12,
                          required: true,
                          maxLength: 100,
                          errorMessage: 'Enter a valid email address',
                          value: 'pauline@example.com',
                        ),
                        DataFormField.spinner(
                          tag: 'customer_type',
                          required: false,
                          weight: 12,
                          showTitle: true,
                          title: 'Customer type',
                          hint: 'Select a customer type',
                          onChange: (model) {
                            id = model!.id;
                            setState(() {});
                          },
                          items: [
                            SpinnerDataModel(
                              name: 'Retail',
                              id: 0,
                            ),
                            SpinnerDataModel(
                              name: 'Wholesale',
                              id: 1,
                            ),
                            SpinnerDataModel(
                              name: 'Partner',
                              id: 2,
                            ),
                          ],
                        ),
                        DataFormField.spinner(
                          tag: 'customer_segment',
                          required: false,
                          weight: 6,
                          title: 'Segment',
                          onChange: (model) {},
                          items: [
                            SpinnerDataModel(
                                name: 'Bronze', id: 0, isSelected: id == 0),
                            SpinnerDataModel(
                              name: 'Silver',
                              id: 1,
                              isSelected: id == 1,
                            ),
                            SpinnerDataModel(
                                name: 'Gold', id: 2, isSelected: id == 2),
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
                child: form = DataForm.multiSection(context,
                    style: _sampleFormStyle(),
                    sections: [
                      FormSection(sectionTitle: 'User information', fields: [
                        DataFormField.text(
                          value: 'Pauline',
                          tag: 'first_name',
                          title: 'First name',
                          minLine: 1,
                          maxLine: 1,
                        ),
                        DataFormField.text(
                          value: 'Njeri',
                          tag: 'middle_name',
                          title: 'Middle name',
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
                          title: 'Preferred package',
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
                            RadioDataModel(title: 'Starter', isSelected: false),
                            RadioDataModel(title: 'Premium', isSelected: false),
                          ],
                          callBack: (data) {},
                        ),
                        DataFormField.datePicker(
                          tag: 'licenceExpireDate',
                          title: 'Licence expiry date',
                          weight: 12,
                          required: false,
                          initialDate: DataDate(day: 10, month: 5, year: 2023),
                          errorMessage: 'Select a licence expiry date',
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
                              name: 'non-binary',
                              id: 3,
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
                            errorMessage: 'Enter the market name',
                          ),
                          DataFormField.textPlain(
                            hint: 'Street, city, and building',
                            tag: 'lastName',
                            title: 'Market address',
                            maxLine: 4,
                            maxLength: 233,
                            showCounter: false,
                            weight: 12,
                            prefixWidget: const Icon(Icons.location_city,
                                color: Colors.blue),
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
                                name: 'Convenience store',
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
                child: form = DataForm.multiSection(
                  context,
                  style: _sampleFormStyle(),
                  sections: [
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
                  ],
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
                        debugPrint('Form is valid: $isValid');
                        debugPrint('Form values: $map');

                        // Show validation result to user
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(isValid
                                ? 'Form submitted successfully!'
                                : 'Please check required fields'),
                            backgroundColor:
                                isValid ? Colors.green : Colors.red,
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

// ---------------------------------------------------------------------------
// Rules Engine example
//
// Shows two ways to supply visibility rules:
//
//  1. JSON string (rulesJson) — great for remote config or dynamic forms.
//     Used here for all section-level rules.
//
//  2. Dart API on FormFieldModel.rules — set directly on the model after
//     field construction. Used here to show "Student ID" only when
//     the Occupation spinner is set to "Student" (independent of the section
//     rule).
//
// Behaviour summary:
//  • account_type spinner   → reveals Individual or Business section
//  • occupation  spinner    → within Individual section, reveals Student ID
//  • has_vehicle bool       → reveals Vehicle section
// ---------------------------------------------------------------------------

// ignore: must_be_immutable
class RulesEngineForm extends StatelessWidget {
  RulesEngineForm({super.key});

  late DataForm form;

  // ── Section + field rules as a JSON string ────────────────────────────────
  //
  // SpinnerDataModel values are matched by their `.id` property.
  // Boolean values are compared directly.
  static const String _rulesJson = '''
[
  {
    "target": "section_individual",
    "conditions": [
      { "field": "account_type", "operator": "equals", "value": 1 }
    ],
    "require_all": true,
    "action": "show"
  },
  {
    "target": "section_business",
    "conditions": [
      { "field": "account_type", "operator": "equals", "value": 2 }
    ],
    "require_all": true,
    "action": "show"
  },
  {
    "target": "section_vehicle",
    "conditions": [
      { "field": "has_vehicle", "operator": "equals", "value": true }
    ],
    "require_all": true,
    "action": "show"
  }
]
''';

  @override
  Widget build(BuildContext context) {
    // ── Build fields that need programmatic (Dart API) field-level rules ────
    //
    // "Student ID" is only relevant when occupation == 1 (Student).
    // We set FormFieldModel.rules directly after construction; DataForm._init()
    // picks these up automatically and merges them with the JSON rules above.
    final studentIdField = DataFormField.text(
      tag: 'student_id',
      title: 'Student ID',
      showTitle: true,
      weight: 12,
      required: true,
      errorMessage: 'Student ID is required for students',
    );
    studentIdField.model?.rules = [
      FormRule(
        target: 'student_id',
        conditions: [
          RuleCondition(
            fieldTag: 'occupation',
            operator: RuleOperator.equals,
            value: 1, // id 1 = Student
          ),
        ],
        action: RuleAction.show,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Rules Engine')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16.0),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: const Text(
                '1. Pick an account type → matching section appears.\n'
                '2. Inside Individual, set Occupation to Student → Student ID appears.\n'
                '3. Toggle "Has Vehicle" → vehicle section slides in/out.',
                style: TextStyle(fontSize: 13),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: form = DataForm.multiSection(
                  context,
                  style: _sampleFormStyle(),

                  // ── All section rules come from the JSON string ────────────
                  rulesJson: _rulesJson,

                  sections: [
                    // ── Always visible ───────────────────────────────────────
                    FormSection(
                      sectionTitle: 'Account Setup',
                      fields: [
                        DataFormField.spinner(
                          tag: 'account_type',
                          title: 'Account Type',
                          showTitle: true,
                          weight: 12,
                          required: true,
                          errorMessage: 'Please select an account type',
                          hint: 'Select account type…',
                          items: [
                            SpinnerDataModel(name: 'Individual', id: 1),
                            SpinnerDataModel(name: 'Business', id: 2),
                          ],
                          onChange: (_) {},
                        ),
                        DataFormField.boolSwitch(
                          tag: 'has_vehicle',
                          title: 'Has Vehicle?',
                          showTitle: true,
                          weight: 12,
                        ),
                      ],
                    ),

                    // ── Individual Details ───────────────────────────────────
                    // Section tag matches "section_individual" in the JSON rule.
                    // "Student ID" (studentIdField) uses a Dart-API field rule.
                    FormSection(
                      tag: 'section_individual',
                      sectionTitle: 'Individual Details',
                      fields: [
                        DataFormField.text(
                          tag: 'full_name',
                          title: 'Full Name',
                          showTitle: true,
                          weight: 12,
                          required: true,
                          errorMessage: 'Full name is required',
                        ),
                        DataFormField.datePicker(
                          tag: 'date_of_birth',
                          title: 'Date of Birth',
                          showTitle: true,
                          weight: 12,
                          required: true,
                          errorMessage: 'Date of birth is required',
                        ),
                        DataFormField.spinner(
                          tag: 'occupation',
                          title: 'Occupation',
                          showTitle: true,
                          weight: 12,
                          required: false,
                          hint: 'Select occupation…',
                          items: [
                            SpinnerDataModel(name: 'Student', id: 1),
                            SpinnerDataModel(name: 'Employee', id: 2),
                            SpinnerDataModel(name: 'Self-employed', id: 3),
                          ],
                          onChange: (_) {},
                        ),
                        // Field-level rule set via Dart API above.
                        studentIdField,
                      ],
                    ),

                    // ── Business Details ─────────────────────────────────────
                    FormSection(
                      tag: 'section_business',
                      sectionTitle: 'Business Details',
                      fields: [
                        DataFormField.text(
                          tag: 'company_name',
                          title: 'Company Name',
                          showTitle: true,
                          weight: 12,
                          required: true,
                          errorMessage: 'Company name is required',
                        ),
                        DataFormField.text(
                          tag: 'tax_number',
                          title: 'Tax / VAT Number',
                          showTitle: true,
                          weight: 6,
                          required: true,
                          errorMessage: 'Tax number is required',
                        ),
                        DataFormField.mobile(
                          tag: 'business_phone',
                          title: 'Business Phone',
                          showTitle: true,
                          weight: 6,
                          required: false,
                        ),
                        DataFormField.email(
                          tag: 'business_email',
                          title: 'Business Email',
                          showTitle: true,
                          weight: 12,
                          required: true,
                          errorMessage: 'A valid business email is required',
                        ),
                      ],
                    ),

                    // ── Vehicle Details ──────────────────────────────────────
                    // Shown when has_vehicle boolean is true (JSON rule).
                    FormSection(
                      tag: 'section_vehicle',
                      sectionTitle: 'Vehicle Details',
                      fields: [
                        DataFormField.text(
                          tag: 'vehicle_registration',
                          title: 'Registration Number',
                          showTitle: true,
                          weight: 6,
                          required: true,
                          errorMessage: 'Registration number is required',
                        ),
                        DataFormField.text(
                          tag: 'vehicle_model',
                          title: 'Make & Model',
                          showTitle: true,
                          weight: 6,
                          required: false,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: () {
                  final isValid = form.isValid();
                  final values = form.onSubmit();
                  debugPrint('Valid: $isValid');
                  debugPrint('Values: $values');

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isValid
                            ? 'Submitted — ${values.length} visible field(s) collected.'
                            : 'Please fill in all required visible fields.',
                      ),
                      backgroundColor: isValid ? Colors.green : Colors.red,
                    ),
                  );
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section constructor rulesJson example
//
// Demonstrates the new constructor APIs without changing the existing rules
// engine example above:
//  • FormSection.rulesJson controls whole-section visibility.
//  • DataFormField.rulesJson controls one field inside a visible section.
//  • Empty JSON targets are resolved to the section tag or field tag.
// ---------------------------------------------------------------------------

// ignore: must_be_immutable
class SectionRulesJsonForm extends StatelessWidget {
  SectionRulesJsonForm({super.key});

  late DataForm form;

  static const String _grantSectionRulesJson = '''
  {
    "target": "",
    "conditions": [
      { "field": "project_type", "operator": "equals", "value": 1 }
    ],
    "require_all": true,
    "action": "show"
  }
''';

  static const String _commercialSectionRulesJson = '''
  {
    "target": "",
    "conditions": [
      { "field": "project_type", "operator": "equals", "value": 2 }
    ],
    "require_all": true,
    "action": "show"
  }
''';

  static const String _budgetFieldRulesJson = '''
  {
    "target": "",
    "conditions": [
      { "field": "needs_budget", "operator": "equals", "value": true }
    ],
    "require_all": true,
    "action": "show"
  }
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Section rulesJson')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16.0),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: const Text(
                '1. Select Grant or Commercial to reveal a section.\n'
                '2. In Grant, toggle "Needs budget" to reveal Budget Amount.\n'
                '3. These rules are passed through section and field constructors.',
                style: TextStyle(fontSize: 13),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: form = DataForm.multiSection(
                  context,
                  style: _sampleFormStyle(),
                  sections: [
                    FormSection(
                      sectionTitle: 'Project Setup',
                      fields: [
                        DataFormField.spinner(
                          tag: 'project_type',
                          title: 'Project Type',
                          showTitle: true,
                          weight: 12,
                          required: true,
                          errorMessage: 'Select a project type',
                          hint: 'Select project type...',
                          items: [
                            SpinnerDataModel(name: 'Grant', id: 1),
                            SpinnerDataModel(name: 'Commercial', id: 2),
                          ],
                          onChange: (_) {},
                        ),
                      ],
                    ),
                    FormSection(
                      tag: 'section_grant',
                      sectionTitle: 'Grant Details',
                      rulesJson: _grantSectionRulesJson,
                      fields: [
                        DataFormField.text(
                          tag: 'grant_name',
                          title: 'Grant Name',
                          showTitle: true,
                          weight: 12,
                          required: true,
                          errorMessage: 'Grant name is required',
                        ),
                        DataFormField.boolSwitch(
                          tag: 'needs_budget',
                          title: 'Needs budget?',
                          showTitle: true,
                          weight: 12,
                        ),
                        DataFormField.price(
                          tag: 'budget_amount',
                          title: 'Budget Amount',
                          showTitle: true,
                          weight: 12,
                          required: true,
                          errorMessage: 'Budget amount is required',
                          currencyName: 'USD',
                          rulesJson: _budgetFieldRulesJson,
                        ),
                      ],
                    ),
                    FormSection(
                      tag: 'section_commercial',
                      sectionTitle: 'Commercial Details',
                      rulesJson: _commercialSectionRulesJson,
                      fields: [
                        DataFormField.text(
                          tag: 'client_name',
                          title: 'Client Name',
                          showTitle: true,
                          weight: 12,
                          required: true,
                          errorMessage: 'Client name is required',
                        ),
                        DataFormField.email(
                          tag: 'client_email',
                          title: 'Client Email',
                          showTitle: true,
                          weight: 12,
                          required: true,
                          errorMessage: 'Client email is required',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: () {
                  final isValid = form.isValid();
                  final values = form.onSubmit();
                  debugPrint('Valid: $isValid');
                  debugPrint('Values: $values');

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isValid
                            ? 'Submitted — ${values.length} visible field(s) collected.'
                            : 'Please fill in all required visible fields.',
                      ),
                      backgroundColor: isValid ? Colors.green : Colors.red,
                    ),
                  );
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
