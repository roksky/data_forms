import 'package:flutter/material.dart';
import 'package:data_forms/core/field_callback.dart';
import 'package:data_forms/core/form_style.dart';
import 'package:data_forms/enums/field_status.dart';
import 'package:data_forms/rules/form_rule.dart';
import 'package:data_forms/rules/rules_engine.dart';
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
    List<FormRule>? rules,
    String? rulesJson,
  }) {
    style ??=
        GSFormUtils.checkIfDarkModeEnabled(context)
            ? style ?? FormStyle.singleSectionFormDefaultDarkStyle
            : FormStyle.singleSectionFormDefaultStyle;
    sections = [FormSection(style: style, sectionTitle: null, fields: fields)];
    _init(rules: rules, rulesJson: rulesJson);
  }

  DataForm.multiSection(
    BuildContext context, {
    super.key,
    this.style,
    required this.sections,
    StateManager? myStateManager,
    List<FormRule>? rules,
    String? rulesJson,
  }) {
    style ??=
        GSFormUtils.checkIfDarkModeEnabled(context)
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
    _init(rules: rules, rulesJson: rulesJson);
  }

  /// Collect all rules (form-level + field-level) and attach the engine to
  /// [stateManager].
  void _init({List<FormRule>? rules, String? rulesJson}) {
    final allRules = <FormRule>[
      ...?rules,
      if (rulesJson != null) ...FormRule.listFromString(rulesJson),
    ];

    // Collect field-level rules from all sections.
    for (final section in sections) {
      for (final widget in section.fields) {
        if (widget is DataFormField) {
          final fieldRules = widget.model?.rules;
          if (fieldRules != null && fieldRules.isNotEmpty) {
            for (final rule in fieldRules) {
              // Auto-fill target with the field's own tag if not already set.
              final resolved = rule.target.isEmpty
                  ? FormRule(
                      target: widget.model!.tag,
                      conditions: rule.conditions,
                      requireAll: rule.requireAll,
                      action: rule.action,
                    )
                  : rule;
              allRules.add(resolved);
            }
          }
        }
      }
    }

    if (allRules.isNotEmpty) {
      stateManager.rulesEngine = RulesEngine(rules: allRules);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => stateManager,
      child: Column(children: sections),
    );
  }

  /// Validates all currently **visible** fields.
  ///
  /// Hidden fields (those whose [isHiddenByRule] is `true` or whose section is
  /// hidden) are excluded from validation and do not affect the result.
  bool isValid() {
    bool isValid = true;
    for (var section in sections) {
      // Skip hidden sections entirely.
      final sectionVisible =
          section.tag == null || stateManager.isVisible(section.tag!);
      if (!sectionVisible) continue;

      for (var field in section.fields) {
        if (field is DataFormField) {
          // Skip hidden fields.
          final fieldVisible = stateManager.isVisible(field.model?.tag ?? '');
          if (!fieldVisible) continue;

          bool fieldValidation = (field.child as FormFieldCallBack).isValid();
          field.model?.status =
              fieldValidation
                  ? FormFieldStatusEnum.success
                  : FormFieldStatusEnum.error;
          isValid = isValid && fieldValidation;
          field.update();
        }
      }
    }
    return isValid;
  }

  /// Collects values from all currently **visible** fields.
  ///
  /// Hidden fields and fields inside hidden sections are excluded from the
  /// returned map.
  Map<String, FormFieldValue> onSubmit() {
    Map<String, FormFieldValue> data = {};
    for (var section in sections) {
      final sectionVisible =
          section.tag == null || stateManager.isVisible(section.tag!);
      if (!sectionVisible) continue;

      for (var field in section.fields) {
        if (field is DataFormField) {
          final fieldVisible = stateManager.isVisible(field.model?.tag ?? '');
          if (!fieldVisible) continue;

          data[field.model?.tag ?? ''] =
              (field.child as FormFieldCallBack).getValue();
        }
      }
    }
    return data;
  }
}
