import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:data_forms/model/fields_model/repeating_group_model.dart';
import 'package:data_forms/core/field_callback.dart';
import 'package:data_forms/core/form_style.dart';
import 'package:data_forms/model/state_manager.dart';
import '../field.dart';
import 'package:uuid/uuid.dart';
import 'notifyable_stateful_widget.dart';

// ignore: must_be_immutable
class FormRepeatingGroupField
    extends NotifiableStatefulWidget<List<Map<String, FormFieldValue>>> {
  final FormRepeatingGroupModel model;
  final FormStyle formStyle;
  List<List<DataFormField>> groupInstances = [];

  FormRepeatingGroupField(this.model, this.formStyle, {super.key}) {
    // Initialize with at least one group if minItems is set or default to 1
    int initialCount = model.minItems ?? 1;
    if (initialCount > 0) {
      for (int i = 0; i < initialCount; i++) {
        addNewGroup();
      }
    }
  }

  @override
  State<FormRepeatingGroupField> createState() =>
      _FormRepeatingGroupFieldState();

  void addNewGroup() {
    var groupId = const Uuid().v4();
    List<DataFormField> newGroup =
        model.fields.map((field) => _copyFieldModel(field, groupId)).toList();
    groupInstances.add(newGroup);
  }

  void removeGroup(int index) {
    if (groupInstances.length > (model.minItems ?? 0)) {
      groupInstances.removeAt(index);
    }
  }

  DataFormField _copyFieldModel(DataFormField field, String groupId) {
    final sourceTag = field.model!.tag;
    return field.copyWithTag(
      '${sourceTag}_group_$groupId',
      key: ValueKey('${_widgetKeyPrefix(field)}_$groupId'),
    );
  }

  String _widgetKeyPrefix(DataFormField field) {
    return '${model.tag}_${field.model!.tag}';
  }

  @override
  bool isValid() {
    if ((model.minItems ?? 0) > 0 &&
        groupInstances.length < (model.minItems ?? 0)) {
      return false;
    }

    for (var group in groupInstances) {
      for (var field in group) {
        final child = field.child;
        if (child is FormFieldCallBack) {
          final callback = child as FormFieldCallBack;
          if (!callback.isValid()) {
            return false;
          }
        }

        // Before a copied group field is mounted, it has no callback child yet.
        // Keep direct model validation available for pure unit tests and callers
        // that validate a repeating group before rendering it.
        if (child == null && !_isModelValueValid(field)) {
          return false;
        }
      }
    }
    return true;
  }

  bool _isModelValueValid(DataFormField field) {
    final fieldModel = field.model;
    if (fieldModel == null) return true;

    final value = fieldModel.value;
    final textValue = value?.toString() ?? '';

    if (fieldModel.validateRegEx != null) {
      return fieldModel.validateRegEx!.hasMatch(textValue);
    }

    if (fieldModel.required ?? false) {
      if (value is Iterable) return value.isNotEmpty;
      if (value is Map) return value.isNotEmpty;
      return textValue.isNotEmpty;
    }

    return true;
  }

  @override
  FormFieldValue<List<Map<String, FormFieldValue>>> getValue() {
    List<Map<String, FormFieldValue>> values = [];

    for (var group in groupInstances) {
      Map<String, FormFieldValue> groupValue = {};
      for (var field in group) {
        final child = field.child;
        if (child is FormFieldCallBack) {
          final callback = child as FormFieldCallBack;
          groupValue[field.model!.tag] = callback.getValue();
        }
      }
      values.add(groupValue);
    }

    return FormFieldValue.repeatingGroup(values);
  }
}

class _FormRepeatingGroupFieldState extends State<FormRepeatingGroupField> {
  // receives a collection of fields and returns the widgets
  Widget _buildFieldWidgets(List<DataFormField> fields) {
    List<Widget> rows = [];
    List<Widget> currentRow = [];
    int currentRowSum = 0;

    for (DataFormField field in fields) {
      field.formStyle = field.formStyle ?? FormStyle();
      int fieldWeight = field.model?.weight ?? 12;

      // If adding this field would exceed 12 or we have no space, start a new row
      if (currentRowSum + fieldWeight > 12 && currentRow.isNotEmpty) {
        rows.add(Row(children: currentRow));
        currentRow = [];
        currentRowSum = 0;
      }

      // Add field to current row
      currentRow.add(
        Expanded(
          flex: fieldWeight,
          child: Padding(padding: const EdgeInsets.all(4.0), child: field),
        ),
      );
      currentRowSum += fieldWeight;

      // If we've reached exactly 12, complete the row
      if (currentRowSum == 12) {
        rows.add(Row(children: currentRow));
        currentRow = [];
        currentRowSum = 0;
      }
    }

    // Add any remaining fields in the last row
    if (currentRow.isNotEmpty) {
      rows.add(Row(children: currentRow));
    }

    return Column(children: rows);
  }

  @override
  Widget build(BuildContext context) {
    final stateManager = Provider.of<StateManager>(context);

    return Column(
      children: [
        ...widget.groupInstances.asMap().entries.map((entry) {
          int groupIndex = entry.key;
          List<DataFormField> group = entry.value;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Group header with remove button
                  if (widget.groupInstances.length >
                      (widget.model.minItems ?? 0))
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.model.title ?? "Group"} ${groupIndex + 1}',
                          style: widget.formStyle.titleTextStyle,
                        ),
                        IconButton(
                          icon:
                              widget.model.removeIcon ??
                              const Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            setState(() {
                              widget.removeGroup(groupIndex);
                            });
                            // Update state manager
                            stateManager.set(
                              widget.model.tag,
                              widget.getValue().value,
                            );
                          },
                        ),
                      ],
                    ),

                  // Fields in this group
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: _buildFieldWidgets(group),
                  ),
                ],
              ),
            ),
          );
        }),

        // Add button
        if (widget.model.maxItems == null ||
            widget.groupInstances.length <
                (widget.model.maxItems ?? double.infinity))
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  widget.addNewGroup();
                });
                // Update state manager
                stateManager.set(widget.model.tag, widget.getValue().value);
              },
              icon: widget.model.addIcon ?? const Icon(Icons.add),
              label: Text(widget.model.addButtonText ?? 'Add Item'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}
