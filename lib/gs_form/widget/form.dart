import 'package:flutter/material.dart';
import 'package:data_forms/gs_form/core/field_callback.dart';
import 'package:data_forms/gs_form/core/form_style.dart';
import 'package:data_forms/gs_form/enums/field_status.dart';
import 'package:data_forms/gs_form/util/util.dart';
import 'package:provider/provider.dart';

import '../model/state_manager.dart';
import 'field.dart';
import 'section.dart';

// ignore: must_be_immutable
class GSForm extends StatelessWidget {
  GSFormStyle? style;
  late List<GSSection> sections;
  late List<Widget> fields;
  StateManager stateManager = StateManager();

  GSForm.singleSection(BuildContext context,
      {Key? key, this.style, required this.fields})
      : super(key: key) {
    style ??= GSFormUtils.checkIfDarkModeEnabled(context)
        ? style ?? GSFormStyle.singleSectionFormDefaultDarkStyle
        : GSFormStyle.singleSectionFormDefaultStyle;
    sections = [
      GSSection(
        style: style,
        sectionTitle: null,
        fields: fields,
      )
    ];
    GSForm.multiSection(
      context,
      style: style,
      sections: sections,
    );
  }

  GSForm.multiSection(BuildContext context,
      {Key? key, this.style, required this.sections, StateManager? myStateManager})
      : super(key: key) {
    style ??= GSFormUtils.checkIfDarkModeEnabled(context)
        ? style ?? GSFormStyle.multiSectionFormDefaultDarkStyle
        : GSFormStyle.multiSectionFormDefaultStyle;
    if (myStateManager != null) {
      stateManager = myStateManager;
    }
    for (var element in sections) {
      element.style = style;

      for (var field in element.fields) {
        if (field is GSField) {
          field.stateManager = stateManager;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => stateManager,
      child: Column(
        children: sections,
      ),
    );
  }

  bool isValid() {
    bool isValid = true;
    for (var section in sections) {
      for (var field in section.fields) {
        if (field is GSField) {
          bool fieldValidation = (field.child as GSFieldCallBack).isValid();
          field.model?.status = fieldValidation
              ? GSFieldStatusEnum.success
              : GSFieldStatusEnum.error;
          isValid = isValid && fieldValidation;
          field.update();
        }
      }
    }
    return isValid;
  }

  Map<String, dynamic> onSubmit() {
    Map<String, dynamic> data = {};
    for (var section in sections) {
      for (var filed in section.fields) {
        if (filed is GSField) {
          data[filed.model?.tag ?? ''] =
              (filed.child as GSFieldCallBack).getValue();
        }
      }
    }
    return data;
  }
}
