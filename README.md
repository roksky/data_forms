# DataForms

A comprehensive Flutter library for building dynamic, data-driven forms with extensive field types, validation, and state management. DataForms simplifies the process of creating complex forms by providing a declarative API and built-in handling for various input types, from simple text fields to complex media pickers and location selectors.

[![pub package](https://img.shields.io/pub/v/data_forms.svg)](https://pub.dev/packages/data_forms)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Features

✨ **Rich Field Types**: 25+ built-in field types covering text, dates, media, location, and more  
📱 **Responsive Design**: Automatic layout adaptation with configurable weights  
🔧 **Form Validation**: Built-in validation with custom rules and error handling  
🎨 **Customizable Styling**: Comprehensive theming and styling options  
📦 **State Management**: Integrated state management for complex forms  
🔄 **Dynamic Forms**: Support for conditional fields and dynamic form structure  
👥 **Repeating Groups**: Handle dynamic lists and repeating form sections  
🌍 **Internationalization**: Full support for multiple languages  

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  data_forms: ^2.3.1
```

Then run:

```bash
flutter pub get
```

## Quick Start

### Basic Single Section Form

```dart
import 'package:flutter/material.dart';
import 'package:data_forms/data_forms.dart';

class MyForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final form = DataForm.singleSection(
      context,
      style: FormStyle(
        titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      fields: [
        DataFormField.text(
          tag: 'name',
          title: 'Full Name',
          required: true,
          weight: 12,
        ),
        DataFormField.email(
          tag: 'email',
          title: 'Email Address',
          required: true,
          weight: 12,
        ),
        DataFormField.mobile(
          tag: 'phone',
          title: 'Phone Number',
          weight: 6,
        ),
        DataFormField.datePicker(
          tag: 'birthdate',
          title: 'Birth Date',
          weight: 6,
        ),
      ],
    );

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(child: form),
            ElevatedButton(
              onPressed: () {
                if (form.isValid()) {
                  Map<String, FormFieldValue> values = form.onSubmit();
                  // Process form data
                  print(values);
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Multi-Section Form

```dart
DataForm.multiSection(
  context,
  sections: [
    FormSection(
      sectionTitle: 'Personal Information',
      fields: [
        DataFormField.text(tag: 'firstName', title: 'First Name'),
        DataFormField.text(tag: 'lastName', title: 'Last Name'),
      ],
    ),
    FormSection(
      sectionTitle: 'Contact Details',
      fields: [
        DataFormField.email(tag: 'email', title: 'Email'),
        DataFormField.mobile(tag: 'phone', title: 'Phone'),
      ],
    ),
  ],
);
```

## Supported Field Types

DataForms supports 25+ field types to cover virtually any form requirement:

### Text Input Fields
- **`text`** - Single/multi-line text input
- **`textPlain`** - Plain text with minimal styling
- **`password`** - Obscured text input
- **`email`** - Email with built-in validation
- **`mobile`** - Phone number input
- **`masked`** - Text with input masking

### Numeric Fields  
- **`number`** - General numeric input
- **`integer`** - Whole numbers only
- **`double`** - Decimal numbers
- **`price`** - Currency/price input
- **`pinCode`** - PIN/code input

### Date and Time
- **`date`** - Single date picker
- **`dateRange`** - Date range selection
- **`time`** - Time picker

### Selection Fields
- **`spinner`** - Dropdown selection
- **`radioGroup`** - Radio button groups
- **`checkList`** - Multiple checkbox selection
- **`boolean`** - Switch/toggle input

### Media and Files
- **`imagePicker`** - Single image selection
- **`multiImagePicker`** - Multiple image selection
- **`filePicker`** - File selection
- **`multiMediaPicker`** - Video and image selection
- **`signature`** - Digital signature capture

### Location and Scanning
- **`location`** - GPS location capture
- **`locationTree`** - Hierarchical location selection
- **`qrScanner`** - QR code scanning
- **`barcode`** - Barcode scanning

### Advanced Fields
- **`bankCard`** - Credit card input with validation
- **`repeatingGroup`** - Dynamic form sections

### Field Configuration Examples

#### Text Field with Validation
```dart
DataFormField.text(
  tag: 'description',
  title: 'Product Description',
  minLine: 3,
  maxLine: 5,
  maxLength: 500,
  required: true,
  weight: 12,
  helpMessage: 'Enter a detailed description',
  errorMessage: 'Description is required',
  validateRegEx: RegExp(r'^[a-zA-Z0-9\s]+$'),
)
```

#### Dropdown with Custom Options
```dart
DataFormField.spinner(
  tag: 'country',
  title: 'Country',
  required: true,
  weight: 6,
  items: [
    SpinnerDataModel(name: 'United States', id: 1),
    SpinnerDataModel(name: 'Canada', id: 2),
    SpinnerDataModel(name: 'United Kingdom', id: 3),
  ],
  onChange: (selected) {
    print('Selected: ${selected?.name}');
  },
)
```

#### Date Picker with Range
```dart
DataFormField.datePicker(
  tag: 'eventDate',
  title: 'Event Date',
  required: true,
  weight: 6,
  initialDate: DataDate(day: 1, month: 1, year: 2024),
  firstDate: DataDate(day: 1, month: 1, year: 2024),
  lastDate: DataDate(day: 31, month: 12, year: 2025),
)
```

#### Radio Group with Search
```dart
DataFormField.radioGroup(
  tag: 'size',
  title: 'T-Shirt Size',
  required: true,
  weight: 12,
  searchable: true,
  searchHint: 'Search sizes...',
  items: [
    RadioDataModel(title: 'Small', isSelected: false),
    RadioDataModel(title: 'Medium', isSelected: true),
    RadioDataModel(title: 'Large', isSelected: false),
    RadioDataModel(title: 'Extra Large', isSelected: false),
  ],
  callBack: (selectedItem) {
    print('Size selected: ${selectedItem.title}');
  },
)
```

#### Image Picker
```dart
DataFormField.imagePicker(
  tag: 'profilePhoto',
  title: 'Profile Photo',
  required: true,
  weight: 6,
  maxWidth: 800,
  maxHeight: 600,
  imageQuality: 85,
)
```

#### QR Scanner
```dart
DataFormField.qrScanner(
  tag: 'qrCode',
  title: 'Scan QR Code',
  required: true,
  weight: 12,
  iconWidget: Icon(Icons.qr_code_scanner),
  hint: 'Tap to scan QR code',
)
```

#### Location Field
```dart
DataFormField.location(
  tag: 'meetingLocation',
  title: 'Meeting Location',
  required: true,
  weight: 12,
  enableReadOnly: false,
)
```

## Repeating Groups

Handle dynamic form sections that can be added or removed by users:

```dart
DataFormField.repeatingGroup(
  tag: 'emergencyContacts',
  title: 'Emergency Contacts',
  showTitle: true,
  minItems: 1,
  maxItems: 5,
  addButtonText: 'Add Contact',
  removeButtonText: 'Remove',
  required: true,
  fields: [
    DataFormField.text(
      tag: 'contactName',
      title: 'Contact Name',
      required: true,
      weight: 12,
    ),
    DataFormField.mobile(
      tag: 'contactPhone',
      title: 'Phone Number',
      required: true,
      weight: 6,
    ),
    DataFormField.email(
      tag: 'contactEmail',
      title: 'Email',
      required: false,
      weight: 6,
    ),
  ],
)
```

## Form Processing

### Validation

```dart
// Check if entire form is valid
bool isValid = form.isValid();

// Get validation errors
Map<String, String> errors = form.getErrors();

// Validate specific field
bool fieldValid = form.validateField('email');
```

### Data Extraction

```dart
// Get all form values
Map<String, FormFieldValue> formData = form.onSubmit();

// Access specific field values
FormFieldValue emailValue = formData['email']!;
String email = emailValue.value as String;

// Handle different value types
formData.forEach((key, fieldValue) {
  switch (fieldValue.valueType) {
    case FormFieldValueType.string:
      String stringValue = fieldValue.value as String;
      break;
    case FormFieldValueType.int:
      int intValue = fieldValue.value as int;
      break;
    case FormFieldValueType.dateData:
      DateDataModel dateValue = fieldValue.value as DateDataModel;
      break;
    case FormFieldValueType.spinnerData:
      SpinnerDataModel spinnerValue = fieldValue.value as SpinnerDataModel;
      break;
    // Handle other types...
  }
});
```

### Processing Repeating Groups

```dart
FormFieldValue contactsValue = formData['emergencyContacts']!;
List<Map<String, dynamic>> contacts = contactsValue.value as List<Map<String, dynamic>>;

for (Map<String, dynamic> contact in contacts) {
  String name = contact['contactName'];
  String phone = contact['contactPhone'];
  String email = contact['contactEmail'];
  // Process each contact
}
```

## Styling and Customization

### Form-Level Styling

```dart
DataForm.singleSection(
  context,
  style: FormStyle(
    titleStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.blue,
    ),
    inputDecoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 2),
      ),
    ),
    errorTextStyle: TextStyle(color: Colors.red, fontSize: 12),
    helperTextStyle: TextStyle(color: Colors.grey, fontSize: 11),
  ),
  fields: [...],
)
```

### Field-Level Customization

```dart
DataFormField.text(
  tag: 'customField',
  title: 'Custom Field',
  prefixWidget: Icon(Icons.person, color: Colors.blue),
  postfixWidget: IconButton(
    icon: Icon(Icons.clear),
    onPressed: () => clearField(),
  ),
  style: TextStyle(fontSize: 16),
  decoration: InputDecoration(
    hintText: 'Enter your name',
    filled: true,
    fillColor: Colors.grey[100],
  ),
)
```

## State Management

DataForms includes built-in state management for complex scenarios:

```dart
// Access form state manager
StateManager stateManager = form.stateManager;

// Listen to field changes
stateManager.addListener('email', (value) {
  print('Email changed: $value');
});

// Programmatically update field values
stateManager.updateField('email', 'new@email.com');

// Get field state
FormFieldStatusEnum status = stateManager.getFieldStatus('email');
```

## Advanced Features

### Conditional Fields

```dart
DataFormField.text(
  tag: 'otherReason',
  title: 'Please specify',
  dependsOn: 'reason', // Only show when 'reason' field has a value
  required: true,
  weight: 12,
)
```

### Custom Validation

```dart
DataFormField.text(
  tag: 'username',
  title: 'Username',
  required: true,
  validateRegEx: RegExp(r'^[a-zA-Z0-9_]{3,20}$'),
  errorMessage: 'Username must be 3-20 characters, letters, numbers, and underscores only',
)
```

### Responsive Layout

Fields automatically adapt to screen size using the weight system:

```dart
// Full width on mobile, half width on larger screens
DataFormField.text(tag: 'field1', weight: 12), // Full width
DataFormField.text(tag: 'field2', weight: 6),  // Half width
DataFormField.text(tag: 'field3', weight: 6),  // Half width
DataFormField.text(tag: 'field4', weight: 4),  // Third width
```

## Examples

Check out the `/example` directory for comprehensive examples:

- **Single Section Form**: Basic form with various field types
- **Multi-Section Form**: Complex form with organized sections  
- **Repeating Groups**: Dynamic forms with add/remove functionality
- **Custom Styling**: Advanced theming and customization
- **Data Processing**: Form submission and data handling

To run the examples:

```bash
cd example
flutter run
```

## API Reference

### DataForm

The main form widget that orchestrates field rendering and state management.

#### Constructors

```dart
// Single section form
DataForm.singleSection(
  BuildContext context,
  {
    FormStyle? style,
    required List<DataFormField> fields,
  }
)

// Multi-section form
DataForm.multiSection(
  BuildContext context,
  {
    FormStyle? style,
    required List<FormSection> sections,
  }
)
```

#### Methods

```dart
bool isValid()                           // Check if form is valid
Map<String, FormFieldValue> onSubmit()   // Get form values
Map<String, String> getErrors()          // Get validation errors
void reset()                             // Reset form to initial state
bool validateField(String tag)           // Validate specific field
```

### FormSection

Container for grouping related fields in multi-section forms.

```dart
FormSection({
  required String sectionTitle,
  required List<DataFormField> fields,
  bool? isCollapsible,
  bool? isInitiallyExpanded,
})
```

### DataFormField

Individual form field with extensive customization options.

#### Common Parameters

- **`tag`** (required): Unique identifier for the field
- **`title`**: Display label for the field
- **`required`**: Whether the field is required
- **`weight`**: Layout weight (1-12, 12 = full width)
- **`errorMessage`**: Custom error message
- **`helpMessage`**: Helper text displayed below field
- **`showTitle`**: Whether to show the field title
- **`enableReadOnly`**: Make field read-only
- **`prefixWidget`**: Widget displayed before the input
- **`postfixWidget`**: Widget displayed after the input

## Contributing

We welcome contributions! Please see our [Contributing Guide](#contributing-guide) for details.

### Development Setup

1. **Fork and Clone**
   ```bash
   git clone https://github.com/roksky/data_forms.git
   cd data_forms
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   cd example
   flutter pub get
   ```

3. **Run Tests**
   ```bash
   flutter test
   ```

4. **Run Example**
   ```bash
   cd example
   flutter run
   ```

### Contributing Guide

#### Code Style

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use `flutter format` before committing
- Add documentation for public APIs
- Include tests for new features

#### Pull Request Process

1. **Create Feature Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make Your Changes**
   - Write clean, documented code
   - Add tests for new functionality
   - Update examples if applicable
   - Update CHANGELOG.md

3. **Test Your Changes**
   ```bash
   flutter test
   flutter analyze
   cd example && flutter run
   ```

4. **Submit Pull Request**
   - Provide clear description of changes
   - Reference any related issues
   - Include screenshots for UI changes
   - Ensure CI passes

#### Reporting Issues

When reporting bugs, please include:
- Flutter version (`flutter --version`)
- data_forms version
- Device/platform information
- Minimal reproduction code
- Expected vs actual behavior

#### Feature Requests

For new features:
- Check existing issues first
- Provide clear use case and rationale
- Consider backwards compatibility
- Offer to implement if possible

#### Documentation

Help improve documentation by:
- Fixing typos or unclear explanations
- Adding examples for complex features
- Improving API documentation
- Translating to other languages

### Code Architecture

#### Directory Structure
```
lib/
├── core/               # Core utilities and styles
├── enums/              # Enumeration definitions
├── model/              # Data models and field models
├── screens/            # Specialized screens (QR, signature)
├── util/               # Utility functions
├── values/             # Design tokens and themes
└── widget/             # Form widgets and field implementations
    └── fields/         # Individual field implementations
```

#### Adding New Field Types

1. **Create Field Model**
   ```dart
   // lib/model/fields_model/your_field_model.dart
   class YourFieldModel extends FormFieldModel {
     YourFieldModel({...}) : super(...);
   }
   ```

2. **Implement Field Widget**
   ```dart
   // lib/widget/fields/your_field.dart
   class YourField extends StatefulWidget implements FormFieldCallBack {
     // Implementation
   }
   ```

3. **Add to FormFieldTypeEnum**
   ```dart
   enum FormFieldTypeEnum {
     // existing types...
     yourFieldType,
   }
   ```

4. **Register in DataFormField**
   ```dart
   DataFormField.yourField({...}) {
     model = YourFieldModel(...);
   }
   ```

5. **Export in Library**
   ```dart
   // lib/data_forms.dart
   export 'model/fields_model/your_field_model.dart';
   ```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- 📖 [Documentation](https://github.com/roksky/data_forms)
- 🐛 [Issue Tracker](https://github.com/roksky/data_forms/issues)
- 💬 [Discussions](https://github.com/roksky/data_forms/discussions)

---

Made with ❤️ by the DataForms team