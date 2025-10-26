import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:data_forms/model/fields_model/repeating_group_model.dart';
import 'package:data_forms/model/fields_model/field_model.dart';
import 'package:data_forms/core/field_callback.dart';
import 'package:data_forms/core/form_style.dart';
import 'package:data_forms/model/state_manager.dart';
import 'notifyable_stateful_widget.dart';

// ignore: must_be_immutable
class FormRepeatingGroupField extends NotifiableStatefulWidget<List<Map<String, dynamic>>> {
  final FormRepeatingGroupModel model;
  final FormStyle formStyle;
  List<List<FormFieldModel>> groupInstances = [];

  FormRepeatingGroupField(this.model, this.formStyle, {super.key}) {
    // Initialize with at least one group if minItems is set or default to 1
    int initialCount = model.minItems ?? 1;
    if (initialCount > 0) {
      for (int i = 0; i < initialCount; i++) {
        _addNewGroup();
      }
    }
  }

  @override
  State<FormRepeatingGroupField> createState() => _FormRepeatingGroupFieldState();

  void _addNewGroup() {
    List<FormFieldModel> newGroup = model.fields.map((field) => _copyFieldModel(field, groupInstances.length)).toList();
    groupInstances.add(newGroup);
  }

  void _removeGroup(int index) {
    if (groupInstances.length > (model.minItems ?? 0)) {
      groupInstances.removeAt(index);
    }
  }

  FormFieldModel _copyFieldModel(FormFieldModel field, int groupIndex) {
    // Create a deep copy of the field model with a new tag
    var copiedField = field; // This is a shallow copy for now
    copiedField.tag = '${field.tag.split('_')[0]}_group_$groupIndex';
    copiedField.value = null; // Reset value for new instance
    return copiedField;
  }

  @override
  bool isValid() {
    // Check if minimum items requirement is met
    if ((model.minItems ?? 0) > 0 && groupInstances.length < (model.minItems ?? 0)) {
      return false;
    }

    // Validate all fields in all groups
    for (var group in groupInstances) {
      for (var field in group) {
        if (field.required ?? false) {
          // Basic validation - you may need to implement more sophisticated validation
          if (field.value == null || field.value == '') {
            return false;
          }
        }
      }
    }
    return true;
  }

  @override
  FormFieldValue<List<Map<String, dynamic>>> getValue() {
    List<Map<String, dynamic>> values = [];
    
    for (var group in groupInstances) {
      Map<String, dynamic> groupValue = {};
      for (var field in group) {
        groupValue[field.tag] = field.value;
      }
      values.add(groupValue);
    }
    
    return FormFieldValue.repeatingGroup(values);
  }
}

class _FormRepeatingGroupFieldState extends State<FormRepeatingGroupField> {
  
  Widget _buildFieldWidget(FormFieldModel fieldModel) {
    // For now, return a simple text field as placeholder
    // You would need to implement proper field creation based on field type
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text('Field: ${fieldModel.tag} (${fieldModel.type})'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stateManager = Provider.of<StateManager>(context);
    
    return Column(
      children: [
        ...widget.groupInstances.asMap().entries.map((entry) {
          int groupIndex = entry.key;
          List<FormFieldModel> group = entry.value;
          
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Group header with remove button
                  if (widget.groupInstances.length > (widget.model.minItems ?? 0))
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.model.title ?? "Group"} ${groupIndex + 1}',
                          style: widget.formStyle.titleTextStyle,
                        ),
                        IconButton(
                          icon: widget.model.removeIcon ?? const Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            setState(() {
                              widget._removeGroup(groupIndex);
                            });
                            // Update state manager
                            stateManager.set(widget.model.tag, widget.getValue().value);
                          },
                        ),
                      ],
                    ),
                  
                  // Fields in this group
                  ...group.map((fieldModel) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: _buildFieldWidget(fieldModel),
                    );
                  }),
                ],
              ),
            ),
          );
        }),
        
        // Add button
        if (widget.model.maxItems == null || 
            widget.groupInstances.length < (widget.model.maxItems ?? double.infinity))
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  widget._addNewGroup();
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