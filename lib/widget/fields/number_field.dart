import 'package:flutter/material.dart';
import 'package:data_forms/core/field_callback.dart';

import 'package:data_forms/core/form_style.dart';
import 'package:data_forms/model/fields_model/number_model.dart';
import 'package:data_forms/model/state_manager.dart';
import 'notifyable_stateful_widget.dart';

// ignore: must_be_immutable
class FormNumberField extends NotifiableStatefulWidget
    implements FormFieldCallBack {
  final FormNumberModel model;
  final FormStyle formStyle;
  TextEditingController? controller;

  FormNumberField(this.model, this.formStyle, {Key? key}) : super(key: key);

  @override
  State<FormNumberField> createState() => _GSNumberFieldState();

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

class _GSNumberFieldState extends State<FormNumberField> {
  @override
  void initState() {
    widget.controller ??= TextEditingController();

    if (widget.model.value != null) {
      widget.controller?.text = widget.model.value;
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FormNumberField oldWidget) {
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
        textAlignVertical: TextAlignVertical.center,
        controller: widget.controller,
        maxLength: widget.model.maxLength,
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
          counter:
              (widget.model.showCounter ?? false) ? null : const Offstage(),
          hintText: widget.model.hint,
          counterStyle: widget.formStyle.fieldHintStyle,
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

class GSIntegerField extends FormNumberField {
  GSIntegerField(super.model, super.formStyle);

  @override
  getValue() {
    var value = controller!.text.replaceAll(",", "");
    return int.parse(value);
  }
}

class GSDoubleField extends FormNumberField {
  GSDoubleField(super.model, super.formStyle);

  @override
  getValue() {
    var value = controller!.text.replaceAll(",", "");
    return double.parse(value);
  }
}
