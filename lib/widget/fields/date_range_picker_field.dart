// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:data_forms/core/field_callback.dart';
import 'package:data_forms/model/data_model/date_data_model.dart';
import 'package:data_forms/model/fields_model/date_range_picker_model.dart';
import 'package:data_forms/util/util.dart';
import 'package:intl/intl.dart';

import 'package:data_forms/core/form_style.dart';
import 'notifyable_stateful_widget.dart';

class FormDateRangePickerField
    extends NotifiableStatefulWidget<DateDataRangeModel> {
  final FormDateRangePickerModel model;
  final FormStyle formStyle;

  String selectedDateText = '';
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  DateTime? selectedGregorianStartDate;
  DateTime? selectedGregorianEndDate;
  late BuildContext context;

  late DateTime gregorianInitialStartDate;
  late DateTime gregorianInitialEndDate;
  late DateTime gregorianAvailableFrom;
  late DateTime gregorianAvailableTo;

  bool isDateSelected = false;

  FormDateRangePickerField(this.model, this.formStyle, {super.key});

  @override
  State<FormDateRangePickerField> createState() =>
      _GSDateRangePickerFieldState();

  @override
  FormFieldValue<DateDataRangeModel> getValue() {
    DateDataRangeModel? value = _getData();
    return FormFieldValue.dateDataRange(value);
  }

  @override
  bool isValid() {
    if (!(model.required ?? false)) {
      return true;
    } else {
      return selectedGregorianEndDate != null &&
          selectedGregorianStartDate != null;
    }
  }

  _getData() {
    return (selectedGregorianEndDate == null &&
            selectedGregorianStartDate == null)
        ? null
        : DateDataRangeModel(
          startDateServerType: selectedGregorianStartDate!,
          endDateServerType: selectedGregorianEndDate!,
          startTimeStamp: selectedGregorianStartDate!.millisecondsSinceEpoch,
          endTimeStamp: selectedGregorianEndDate!.millisecondsSinceEpoch,
          displayStartDateStr: selectedDateText,
          displayEndDateStr: selectedDateText,
        );
  }
}

class _GSDateRangePickerFieldState extends State<FormDateRangePickerField> {
  @override
  void initState() {
    _initialDates();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FormDateRangePickerField oldWidget) {
    _initialDates();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    widget.context = context;
    return SizedBox(
      height: 48.0,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 10.0,
          left: 10.0,
          top: 16,
          bottom: 16,
        ),
        child: InkWell(
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
                    style:
                        widget.isDateSelected
                            ? widget.formStyle.fieldTextStyle
                            : widget.formStyle.fieldHintStyle,
                  ),
                ),
              ),
            ],
          ),
          onTap: () {
            _openGregorianDateRangePicker();
          },
        ),
      ),
    );
  }

  _openGregorianDateRangePicker() async {
    var picked = await showDateRangePicker(
      context: widget.context,
      initialEntryMode: DatePickerEntryMode.calendar,
      initialDateRange: DateTimeRange(
        start: widget.gregorianInitialStartDate,
        end: widget.gregorianInitialEndDate,
      ),
      firstDate: widget.gregorianAvailableFrom,
      lastDate: widget.gregorianAvailableTo,
    );
    if (picked?.start != null && picked?.end != null) {
      widget.selectedGregorianStartDate = picked?.start;
      widget.selectedGregorianEndDate = picked?.end;
      widget.gregorianInitialStartDate = picked!.start;

      widget.gregorianInitialEndDate = picked.end;
      widget.isDateSelected = true;
      _displayGregorianDate();
      update();
    } else {
      widget.isDateSelected = false;
    }
  }

  _initialDates() {
    _initialGregorianDates();
  }

  _initialGregorianDates() {
    if (widget.model.initialStartDate == null) {
      widget.gregorianInitialStartDate = DateTime.now();
    } else {
      widget.gregorianInitialStartDate = DateTime(
        widget.model.initialStartDate!.year,
        widget.model.initialStartDate!.month,
        widget.model.initialStartDate!.day,
      );
      widget.selectedGregorianStartDate = widget.gregorianInitialStartDate;
    }

    if (widget.model.initialEndDate == null) {
      widget.gregorianInitialEndDate = DateTime.now().add(
        const Duration(days: 2),
      );
    } else {
      widget.gregorianInitialEndDate = DateTime(
        widget.model.initialEndDate!.year,
        widget.model.initialEndDate!.month,
        widget.model.initialEndDate!.day,
      );
      widget.selectedGregorianEndDate = widget.gregorianInitialEndDate;
    }
    if (widget.model.initialEndDate != null &&
        widget.model.initialStartDate != null) {
      _displayGregorianDate();
    }

    if (widget.model.availableTo == null) {
      widget.gregorianAvailableTo = DateTime(2100, 1, 1);
    } else {
      widget.gregorianAvailableTo = DateTime(
        widget.model.availableTo!.year,
        widget.model.availableTo!.month,
        widget.model.availableTo!.day,
      );
    }

    _initialGregorianAvailableFromDate();
  }

  _initialGregorianAvailableFromDate() {
    if (widget.model.isPastAvailable ?? false) {
      if (widget.model.availableFrom != null) {
        widget.gregorianAvailableFrom = DateTime(
          widget.model.availableFrom!.year,
          widget.model.availableFrom!.month,
          widget.model.availableFrom!.day,
        );
      } else {
        widget.gregorianAvailableFrom = DateTime(1700, 1, 1);
      }
    } else {
      widget.gregorianAvailableFrom = widget.gregorianInitialStartDate;
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
              '${widget.model.from}: ${DateFormat.yMd().format(widget.selectedGregorianStartDate!)}   ${widget.model.to}: ${DateFormat.yMd().format(widget.selectedGregorianEndDate!)}';
          break;
        case GSDateFormatType.fullText:
          widget.selectedDateText = '${widget.model.from}: ${DateFormat('EEE, MMM d, '
          'yyyy').format(widget.selectedGregorianStartDate!)}   ${widget.model.to}: ${DateFormat('EEE, MMM d, '
          'yyyy').format(widget.selectedGregorianEndDate!)}';
          break;
        case GSDateFormatType.mediumText:
          widget.selectedDateText =
              '${widget.model.from}: ${DateFormat('EEE, MMM d').format(widget.selectedGregorianStartDate!)}   ${widget.model.to}: ${DateFormat('EEE, MMM d').format(widget.selectedGregorianEndDate!)}';
          break;
        case GSDateFormatType.shortText:
          widget.selectedDateText = '${widget.model.from}: ${DateFormat('MMM d, '
          'yyyy').format(widget.selectedGregorianStartDate!)}   ${widget.model.to}: ${DateFormat('MMM d, '
          'yyyy').format(widget.selectedGregorianEndDate!)}';
          break;

        default:
          widget.selectedDateText =
              '${widget.model.from}: ${DateFormat.yMd().format(widget.selectedGregorianStartDate!)}   ${widget.model.to}: ${DateFormat.yMd().format(widget.selectedGregorianEndDate!)}';
          break;
      }
    } else {
      widget.selectedDateText =
          '${widget.model.from}: ${DateFormat.yMd().format(widget.selectedGregorianStartDate!)}   ${widget.model.to}: ${DateFormat.yMd().format(widget.selectedGregorianEndDate!)}';
    }
  }
}
