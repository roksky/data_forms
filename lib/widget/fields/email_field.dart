import 'package:flutter/material.dart';
import 'package:data_forms/core/constant.dart';
import 'package:data_forms/core/field_callback.dart';

import 'package:data_forms/core/form_style.dart';
import 'package:data_forms/model/fields_model/email_model.dart';
import 'package:data_forms/model/state_manager.dart';
import 'notifyable_stateful_widget.dart';

// ignore: must_be_immutable
class FormEmailField extends NotifiableStatefulWidget implements FormFieldCallBack {
  final FormEmailModel model;
  final FormStyle formStyle;
  TextEditingController? controller = TextEditingController();

  FormEmailField(this.model, this.formStyle, {Key? key}) : super(key: key);

  @override
  State<FormEmailField> createState() => _GSEmailFieldState();

  @override
  getValue() {
    return controller!.text;
  }

  @override
  bool isValid() {
    if (model.validateRegEx == null) {
      if (controller!.text.isNotEmpty) {
        return RegExp(FormConstant.emailRegEx).hasMatch(controller!.text);
      }
      if (!(model.required ?? false)) {
        return true;
      }
      return controller!.text.isNotEmpty;
    }
    return model.validateRegEx!.hasMatch(controller!.text);
  }
}

class _GSEmailFieldState extends State<FormEmailField> {
  @override
  void initState() {
    widget.controller ??= TextEditingController();
    if (widget.model.value != null) {
      widget.controller?.text = widget.model.value;
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FormEmailField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.model.value == widget.model.value) {
      widget.controller = oldWidget.controller;
    } else {
      widget.controller ??= TextEditingController();
      widget.controller!.text = widget.model.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.model.value != null) {
      widget.controller?.text = widget.model.value;
    }
    return Padding(
      padding: const EdgeInsets.only(right: 10.0, left: 10.0),
      child: TextField(
        readOnly: widget.model.enableReadOnly ?? false,
        controller: widget.controller,
        maxLength: widget.model.maxLength,
        style: widget.formStyle.fieldTextStyle,
        keyboardType: TextInputType.emailAddress,
        focusNode: widget.model.focusNode,
        textInputAction: widget.model.nextFocusNode != null
            ? TextInputAction.next
            : TextInputAction.done,
        onSubmitted: (_) {
          FocusScope.of(context).requestFocus(widget.model.nextFocusNode);
        },
        decoration: InputDecoration(
          hintText: widget.model.hint,
          counterText: '',
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintStyle: widget.formStyle.fieldHintStyle,
        ),
      ),
    );
  }
}
