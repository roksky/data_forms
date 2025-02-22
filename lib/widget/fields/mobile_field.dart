import 'package:flutter/material.dart';
import 'package:data_forms/core/field_callback.dart';
import 'package:data_forms/core/form_style.dart';
import 'package:data_forms/model/fields_model/mobile_model.dart';

import 'package:data_forms/model/state_manager.dart';
import 'notifyable_stateful_widget.dart';

// ignore: must_be_immutable
class FormMobileField extends NotifiableStatefulWidget
    implements FormFieldCallBack {
  final FormMobileModel model;
  final FormStyle formStyle;
  TextEditingController? controller;

  FormMobileField(this.model, this.formStyle, {Key? key}) : super(key: key);

  @override
  State<FormMobileField> createState() => _GSMobileFieldState();

  @override
  getValue() {
    return controller!.text;
  }

  @override
  bool isValid() {
    if (model.validateRegEx == null) {
      if (!(model.required ?? false)) {
        return true;
      } else {
        return controller!.text.isNotEmpty;
      }
    } else {
      return model.validateRegEx!.hasMatch(controller!.text);
    }
  }
}

class _GSMobileFieldState extends State<FormMobileField> {
  @override
  void initState() {
    widget.controller ??= TextEditingController();

    if (widget.model.value != null) {
      widget.controller?.text = widget.model.value;
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FormMobileField oldWidget) {
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
    return Padding(
      padding: const EdgeInsets.only(right: 10.0, left: 10.0),
      child: TextField(
        readOnly: widget.model.enableReadOnly ?? false,
        textAlign: TextAlign.left,
        controller: widget.controller,
        maxLength: widget.model.maxLength ?? 11,
        style: widget.formStyle.fieldTextStyle,
        keyboardType: TextInputType.phone,
        focusNode: widget.model.focusNode,
        textInputAction: widget.model.nextFocusNode != null
            ? TextInputAction.next
            : TextInputAction.done,
        onSubmitted: (_) {
          FocusScope.of(context).requestFocus(widget.model.nextFocusNode);
        },
        decoration: InputDecoration(
          hintText: widget.model.hint,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          counterText: '',
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintStyle: widget.formStyle.fieldHintStyle,
        ),
      ),
    );
  }
}
