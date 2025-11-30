import 'package:data_forms/screens/signature_collector_screen.dart';
import 'package:data_forms/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:data_forms/core/field_callback.dart';
import 'package:data_forms/core/form_style.dart';
import 'package:data_forms/model/fields_model/signature_model.dart';
import 'notifyable_stateful_widget.dart';

class FormSignatureScreenField extends NotifiableStatefulWidget<String> {
  late FormSignatureModel model;
  final FormStyle formStyle;

  FormSignatureScreenField(this.model, this.formStyle, {super.key});
  String? _signatureSVG;

  @override
  State<FormSignatureScreenField> createState() => _GSSignatureScreenState();

  @override
  FormFieldValue<String> getValue() {
    return FormFieldValue.string(_signatureSVG);
  }

  @override
  bool isValid() {
    if (!(model.required ?? false)) {
      return true;
    } else {
      return _signatureSVG != null;
    }
  }
}

class _GSSignatureScreenState extends State<FormSignatureScreenField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          onTap: () {
            _route(
              context,
              SignatureScreen(
                model: widget.model,
                svgCallback: (value) {
                  widget._signatureSVG = value;
                  setState(() {});
                },
                //byteCallback: (byteData) {},
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.model.iconWidget ?? Container(),
                const SizedBox(height: 6.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: widget.model.required ?? false,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4, left: 4),
                        child: Text(
                          widget.formStyle.requiredText,
                          style: const TextStyle(
                            color: FormColors.red,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      widget.model.title ?? '',
                      style: widget.formStyle.titleTextStyle,
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                widget._signatureSVG == null
                    ? Text(
                      widget.model.hint ?? '',
                      style: widget.formStyle.fieldHintStyle,
                    )
                    : Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SvgPicture.string(
                        widget._signatureSVG!,
                        placeholderBuilder:
                            (_) => Container(
                              color: Colors.lightBlueAccent,
                              child: Center(child: Text('parsing data(svg)')),
                            ),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _route(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute<dynamic>(builder: (BuildContext context) => screen),
    );
  }
}
