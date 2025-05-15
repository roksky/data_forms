import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:flutter/material.dart';

import 'package:data_forms/core/field_callback.dart';
import 'package:data_forms/core/form_style.dart';
import 'package:data_forms/model/fields_model/barcode_scanner_model.dart';
import 'package:data_forms/values/colors.dart';
import 'notifyable_stateful_widget.dart';

class FormBarcodeScannerField extends NotifiableStatefulWidget<String> {
  final FormBarCodeModel model;
  final FormStyle formStyle;

  FormBarcodeScannerField(this.model, this.formStyle, {Key? key})
      : super(key: key);
  String? _scannedValue;

  @override
  State<FormBarcodeScannerField> createState() => _GSBarcodeScannerFieldState();

  @override
  FormFieldValue<String> getValue() {
    return FormFieldValue.string(_scannedValue);
  }

  @override
  bool isValid() {
    if (!(model.required ?? false)) {
      return true;
    } else {
      return _scannedValue?.isNotEmpty ?? false;
    }
  }
}

class _GSBarcodeScannerFieldState extends State<FormBarcodeScannerField> {
  @override
  void initState() {
    super.initState();
    widget._scannedValue = null;
  }

  @override
  void didUpdateWidget(covariant FormBarcodeScannerField oldWidget) {
    widget._scannedValue = null;
    super.didUpdateWidget(oldWidget);
  }

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
            onTap: () async {
              try {
                var result = await BarcodeScanner.scan();
                setState(() {
                  widget._scannedValue = result.rawContent;
                });
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to get barcode')),
                );
              }
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
                  widget._scannedValue == null
                      ? Text(
                          widget.model.hint ?? '',
                          style: widget.formStyle.fieldHintStyle,
                        )
                      : Text(
                          widget._scannedValue ?? '',
                          style: widget.formStyle.fieldTextStyle,
                        ),
                ],
              ),
            )),
      ),
    );
  }
}
