import 'package:flutter/material.dart';
import 'package:data_forms/model/fields_model/bank_card_filed_model.dart';
import 'package:provider/provider.dart';

import '../../core/field_callback.dart';
import '../../core/form_style.dart';
import 'package:data_forms/model/state_manager.dart';
import '../../util/util.dart';
import 'notifyable_stateful_widget.dart';

// ignore: must_be_immutable
class GSBankCardField extends NotifiableStatefulWidget
    implements GSFieldCallBack {
  final GSBankCardModel model;
  final GSFormStyle formStyle;
  TextEditingController? controller;

  GSBankCardField(this.model, this.formStyle, {Key? key}) : super(key: key);

  @override
  State<GSBankCardField> createState() => _GSBankCardFieldState();

  @override
  getValue() {
    return controller!.text.replaceAll(' ', '');
  }

  @override
  bool isValid() {
    if (model.validateRegEx == null) {
      if (!(model.required ?? false)) {
        return true;
      } else {
        return controller!.text.replaceAll(' ', '').length == 16;
      }
    } else {
      return model.validateRegEx!.hasMatch(controller!.text);
    }
  }
}

class _GSBankCardFieldState extends State<GSBankCardField> {
  @override
  void initState() {
    widget.controller ??= TextEditingController();
    if (widget.model.value != null) {
      widget.controller?.text = widget.model.value;
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant GSBankCardField oldWidget) {
    if (oldWidget.model.value == widget.model.value) {
      widget.controller = oldWidget.controller;
    } else {
      widget.controller ??= TextEditingController();
      widget.controller!.text = widget.model.value;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final stateManager = Provider.of<StateManager>(context);
    return Padding(
      padding: const EdgeInsets.only(right: 10.0, left: 10.0),
      child: TextField(
        readOnly: widget.model.enableReadOnly ?? false,
        inputFormatters: [CardNumberFormatter()],
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
        controller: widget.controller,
        maxLines: 1,
        style: widget.formStyle.fieldTextStyle,
        keyboardType: TextInputType.number,
        focusNode: widget.model.focusNode,
        textInputAction: widget.model.nextFocusNode != null
            ? TextInputAction.next
            : TextInputAction.done,
        onSubmitted: (_) {
          FocusScope.of(context).requestFocus(widget.model.nextFocusNode);
        },
        onChanged: (value) {
          stateManager.set(widget.model.tag, value); // Update the model
        },
        decoration: InputDecoration(
          hintText:
              widget.model.hint ?? '- - - -   - - - -   - - - -   - - - -',
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
