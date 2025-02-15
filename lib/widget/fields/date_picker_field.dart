// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:data_forms/core/field_callback.dart';
import 'package:data_forms/core/form_style.dart';
import 'package:data_forms/model/data_model/date_data_model.dart';
import 'package:data_forms/util/util.dart';
import 'package:intl/intl.dart';

import '../../model/fields_model/date_picker_model.dart';
import 'notifyable_stateful_widget.dart';

class GSDatePickerField extends NotifiableStatefulWidget
    implements GSFieldCallBack {
  late GSDatePickerModel model;
  final GSFormStyle formStyle;

  String selectedDateText = '';
  DateTime? selectedGregorianDate;
  late BuildContext context;

  late DateTime gregorianInitialDate;
  late DateTime gregorianAvailableFrom;
  late DateTime gregorianAvailableTo;

  bool isDateSelected = false;

  GSDatePickerField(this.model, this.formStyle, {Key? key}) : super(key: key);

  @override
  State<GSDatePickerField> createState() => _GSDatePickerFieldState();

  @override
  getValue() {
    return _getData();
  }

  @override
  bool isValid() {
    if (!(model.required ?? false)) {
      return true;
    } else {
      return selectedGregorianDate != null;
    }
  }

  _getData() {
    return selectedGregorianDate == null
        ? null
        : DateDataModel(
        dateServerType: selectedGregorianDate!,
        timeStamp: selectedGregorianDate!.millisecondsSinceEpoch,
        showDateStr: selectedDateText);
  }
}

class _GSDatePickerFieldState extends State<GSDatePickerField> {
  @override
  void initState() {
    _initialDates();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant GSDatePickerField oldWidget) {
    if (oldWidget.selectedGregorianDate != null) {
      widget.model.initialDate = GSDate(
          year: oldWidget.selectedGregorianDate!.year,
          month: oldWidget.selectedGregorianDate!.month,
          day: oldWidget.selectedGregorianDate!.day);
    }
    _initialDates();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    widget.context = context;
    return InkWell(
      child: Padding(
        padding:
            const EdgeInsets.only(right: 10.0, left: 10.0, top: 18, bottom: 18),
        child: Row(
          children: [
            Expanded(
              child: Align(
                alignment:
                    widget.model.dateFormatType == GSDateFormatType.numeric
                        ? Alignment.centerLeft
                        : GSFormUtils.isDirectionRTL(context)
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                child: Text(
                  widget.selectedDateText.isEmpty
                      ? widget.model.hint ?? ''
                      : widget.selectedDateText,
                  style: widget.isDateSelected
                      ? widget.formStyle.fieldTextStyle
                      : widget.formStyle.fieldHintStyle,
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        _openGregorianPicker();
      },
    );
  }

  _initialDates() {
    _initialGregorianDates();
  }

  _initialGregorianDates() {
    if (widget.model.initialDate == null) {
      widget.gregorianInitialDate = DateTime.now();
    } else {
      widget.gregorianInitialDate = DateTime(widget.model.initialDate!.year,
          widget.model.initialDate!.month, widget.model.initialDate!.day);
      widget.selectedGregorianDate = widget.gregorianInitialDate;
      _displayGregorianDate();
    }

    if (widget.model.availableTo == null) {
      widget.gregorianAvailableTo = DateTime(2100, 1, 1);
    } else {
      widget.gregorianAvailableTo = DateTime(widget.model.availableTo!.year,
          widget.model.availableTo!.month, widget.model.availableTo!.day);
    }

    _initialGregorianAvailableFromDate();
  }

  _initialGregorianAvailableFromDate() {
    if (widget.model.isPastAvailable ?? false) {
      if (widget.model.availableFrom != null) {
        widget.gregorianAvailableFrom = DateTime(
            widget.model.availableFrom!.year,
            widget.model.availableFrom!.month,
            widget.model.availableFrom!.day);
      } else {
        widget.gregorianAvailableFrom = DateTime(1700, 1, 1);
      }
    } else {
      widget.gregorianAvailableFrom = widget.gregorianInitialDate;
    }
  }

  _openGregorianPicker() async {
    DateTime? picked = await showDatePicker(
      context: widget.context,
      initialDate: widget.gregorianInitialDate,
      firstDate: widget.gregorianAvailableFrom,
      lastDate: widget.gregorianAvailableTo,
    );
    if (picked != null) {
      widget.selectedGregorianDate = picked;
      widget.isDateSelected = true;
      widget.gregorianInitialDate = picked;
      _displayGregorianDate();
      update();
    } else {
      widget.isDateSelected = false;
    }
  }

  update() {
    if (mounted) {
      setState(() {});
    }
  }

  _displayGregorianDate() {
    if (widget.model.dateFormatType != null) {
      switch (widget.model.dateFormatType) {
        case GSDateFormatType.numeric:
          widget.selectedDateText =
              DateFormat.yMd().format(widget.selectedGregorianDate!);
          break;
        case GSDateFormatType.fullText:
          widget.selectedDateText = DateFormat('EEE, MMM d, ' 'yyyy')
              .format(widget.selectedGregorianDate!);
          break;
        case GSDateFormatType.mediumText:
          widget.selectedDateText =
              DateFormat('EEE, MMM d').format(widget.selectedGregorianDate!);
          break;
        case GSDateFormatType.shortText:
          widget.selectedDateText = DateFormat('MMM d, ' 'yyyy')
              .format(widget.selectedGregorianDate!);
          break;
        default:
          widget.selectedDateText =
              DateFormat.yMd().format(widget.selectedGregorianDate!);
          break;
      }
    } else {
      widget.selectedDateText =
          DateFormat.yMd().format(widget.selectedGregorianDate!);
    }
  }
}
