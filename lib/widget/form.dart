import 'package:flutter/material.dart';
import 'package:data_forms/core/field_callback.dart';
import 'package:data_forms/core/form_style.dart';
import 'package:data_forms/enums/field_status.dart';
import 'package:data_forms/util/util.dart';
import 'package:provider/provider.dart';

import 'package:data_forms/model/state_manager.dart';
import 'field.dart';
import 'section.dart';

// ignore: must_be_immutable
class DataForm extends StatelessWidget {
  FormStyle? style;
  late List<FormSection> sections;
  late List<Widget> fields;
  StateManager stateManager = StateManager();

  DataForm.singleSection(
    BuildContext context, {
    super.key,
    this.style,
    required this.fields,
  }) {
    style ??= GSFormUtils.checkIfDarkModeEnabled(context)
        ? style ?? FormStyle.singleSectionFormDefaultDarkStyle
        : FormStyle.singleSectionFormDefaultStyle;
    sections = [FormSection(style: style, sectionTitle: null, fields: fields)];
    DataForm.multiSection(context, style: style, sections: sections);
  }

  DataForm.multiSection(
    BuildContext context, {
    super.key,
    this.style,
    required this.sections,
    StateManager? myStateManager,
  }) {
    style ??= GSFormUtils.checkIfDarkModeEnabled(context)
        ? style ?? FormStyle.multiSectionFormDefaultDarkStyle
        : FormStyle.multiSectionFormDefaultStyle;
    if (myStateManager != null) {
      stateManager = myStateManager;
    }
    for (var element in sections) {
      element.style = style;

      for (var field in element.fields) {
        if (field is DataFormField) {
          field.stateManager = stateManager;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => stateManager,
      child: Column(children: sections),
    );
  }

  bool isValid() {
    bool isValid = true;
    for (var section in sections) {
      for (var field in section.fields) {
        if (field is DataFormField) {
          bool fieldValidation = (field.child as FormFieldCallBack).isValid();
          field.model?.status = fieldValidation
              ? FormFieldStatusEnum.success
              : FormFieldStatusEnum.error;
          isValid = isValid && fieldValidation;
          field.update();
        }
      }
    }
    return isValid;
  }

  Map<String, FormFieldValue> onSubmit() {
    Map<String, FormFieldValue> data = {};
    for (var section in sections) {
      for (var field in section.fields) {
        if (field is DataFormField) {
          data[field.model?.tag ?? ''] = (field.child as FormFieldCallBack)
              .getValue();
        }
      }
    }
    return data;
  }
}
