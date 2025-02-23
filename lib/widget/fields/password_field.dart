// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:data_forms/core/field_callback.dart';

import 'package:data_forms/core/form_style.dart';
import 'package:data_forms/model/fields_model/text_password_model.dart';
import 'package:data_forms/model/state_manager.dart';
import 'notifyable_stateful_widget.dart';

class FormPasswordField extends NotifiableStatefulWidget
    implements FormFieldCallBack {
  late FormPasswordModel model;
  FormStyle formStyle;
  void Function(void Function())? state;
  bool obscured = true;

  TextEditingController? controller;

  FormPasswordField(this.model, this.formStyle, {Key? key}) : super(key: key);

  @override
  State<FormPasswordField> createState() => _GSPasswordFieldState();

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

class _GSPasswordFieldState extends State<FormPasswordField> {
  @override
  void initState() {
    widget.controller ??= TextEditingController();

    if (widget.model.value != null) {
      widget.controller?.text = widget.model.value;
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FormPasswordField oldWidget) {
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
      padding: const EdgeInsetsDirectional.only(start: 10.0),
      child: TextField(
        readOnly: widget.model.enableReadOnly ?? false,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.visiblePassword,
        obscureText: widget.obscured,
        focusNode: widget.model.focusNode,
        style: widget.formStyle.fieldTextStyle,
        controller: widget.controller,
        obscuringCharacter: '●',
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
          suffixIcon: GestureDetector(
            onTap: () {
              _update();
            },
            child: Icon(
              widget.obscured
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_rounded,
            ),
          ),
          hintStyle: widget.formStyle.fieldHintStyle,
        ),
      ),
    );
  }

  _update() {
    if (mounted) {
      setState(() => widget.obscured = !widget.obscured);
    }
  }

  @override
  void dispose() {
    widget.controller?.dispose();
    super.dispose();
  }
}
