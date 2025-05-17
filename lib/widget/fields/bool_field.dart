import 'package:flutter/material.dart';

import 'package:data_forms/core/field_callback.dart';
import 'package:data_forms/core/form_style.dart';
import 'package:data_forms/model/fields_model/bool_switch_model.dart';
import 'notifyable_stateful_widget.dart';

// ignore: must_be_immutable
class FormBoolSwitchField extends NotifiableStatefulWidget<bool> {
  final FormBoolSwitchModel model;
  final FormStyle formStyle;
  bool? value;

  FormBoolSwitchField(this.model, this.formStyle, {super.key});

  @override
  State<FormBoolSwitchField> createState() => _GSBoolSwitchFieldState();

  @override
  FormFieldValue<bool> getValue() {
    return FormFieldValue.bool(value);
  }

  @override
  bool isValid() {
    if (model.required == true && value == null) {
      return false;
    }
    return true;
  }
}

class _GSBoolSwitchFieldState extends State<FormBoolSwitchField> {
  @override
  void initState() {
    super.initState();
    // Set the value on init
    widget.value = widget.model.value;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0, left: 10.0),
      child: Switch(
        // This bool value toggles the switch.
        value: widget.value ?? false,
        activeColor: Colors.red,
        onChanged: (bool value) {
          // This is called when the user toggles the switch.
          setState(() {
            widget.value = value;
          });
        },
      ),
    );
  }
}
