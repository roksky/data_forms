// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:data_forms/core/field_callback.dart';
import 'package:intl/intl.dart';

import 'package:data_forms/core/form_style.dart';
import 'package:data_forms/model/fields_model/price_model.dart';
import 'package:data_forms/model/state_manager.dart';
import 'notifyable_stateful_widget.dart';

class FormPriceField extends NotifiableStatefulWidget<double> {
  late FormPriceModel model;
  FormStyle formStyle;
  TextEditingController? controller;

  FormPriceField(this.model, this.formStyle, {Key? key}) : super(key: key);

  @override
  State<FormPriceField> createState() => _GSPriceFieldState();

  @override
  FormFieldValue<double> getValue() {
    var value = double.parse(controller!.text.replaceAll(',', ''));
    return FormFieldValue.double(value);
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

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern().format(int.parse(s));
}

class _GSPriceFieldState extends State<FormPriceField> {
  @override
  void initState() {
    widget.controller ??= TextEditingController();
    if (widget.model.value != null) {
      widget.controller?.value = TextEditingValue(
        text: widget.model.value.toString(),
        selection: TextSelection.collapsed(
            offset: widget.model.value.toString().length),
      );
      widget.controller?.text = widget.model.value.toString();
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FormPriceField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.model.value == widget.model.value.toString()) {
      widget.controller = oldWidget.controller;
    } else {
      widget.controller ??= TextEditingController();
      widget.controller?.value = TextEditingValue(
        text: widget.model.value.toString(),
        selection: TextSelection.collapsed(
            offset: widget.model.value.toString().length),
      );
      widget.controller?.text = widget.model.value.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0, left: 10.0),
      child: TextField(
        readOnly: widget.model.enableReadOnly ?? false,
        controller: widget.controller,
        maxLength: widget.model.maxLength,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.left,
        focusNode: widget.model.focusNode,
        style: widget.formStyle.fieldTextStyle,
        textInputAction: widget.model.nextFocusNode != null
            ? TextInputAction.next
            : TextInputAction.done,
        onSubmitted: (_) {
          FocusScope.of(context).requestFocus(widget.model.nextFocusNode);
        },
        onChanged: (string) {
          string = widget._formatNumber(string.replaceAll(',', ''));
          widget.controller!.value = TextEditingValue(
            text: string,
            selection: TextSelection.collapsed(offset: string.length),
          );
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
