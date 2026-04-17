import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:data_forms/core/field_callback.dart';
import 'package:data_forms/core/form_style.dart';
import 'package:data_forms/model/fields_model/color_picker_model.dart';
import 'package:data_forms/model/state_manager.dart';
import 'package:data_forms/widget/fields/notifyable_stateful_widget.dart';

const List<Color> _defaultColors = [
  Color(0xFFF44336),
  Color(0xFFE91E63),
  Color(0xFF9C27B0),
  Color(0xFF673AB7),
  Color(0xFF3F51B5),
  Color(0xFF2196F3),
  Color(0xFF03A9F4),
  Color(0xFF00BCD4),
  Color(0xFF009688),
  Color(0xFF4CAF50),
  Color(0xFF8BC34A),
  Color(0xFFCDDC39),
  Color(0xFFFFEB3B),
  Color(0xFFFFC107),
  Color(0xFFFF9800),
  Color(0xFFFF5722),
  Color(0xFF795548),
  Color(0xFF9E9E9E),
  Color(0xFF607D8B),
  Color(0xFF000000),
  Color(0xFFFFFFFF),
];

String _toHex(Color color) {
  final r = (color.r * 255.0).round().clamp(0, 255).toRadixString(16).padLeft(2, '0');
  final g = (color.g * 255.0).round().clamp(0, 255).toRadixString(16).padLeft(2, '0');
  final b = (color.b * 255.0).round().clamp(0, 255).toRadixString(16).padLeft(2, '0');
  return '#$r$g$b'.toUpperCase();
}

Color? _fromHex(String? hex) {
  if (hex == null || hex.isEmpty) return null;
  final cleaned = hex.replaceFirst('#', '');
  if (cleaned.length != 6) return null;
  final value = int.tryParse('FF$cleaned', radix: 16);
  return value != null ? Color(value) : null;
}

class FormColorPickerField extends NotifiableStatefulWidget<String> {
  final FormColorPickerModel model;
  final FormStyle formStyle;
  String? value;

  FormColorPickerField(this.model, this.formStyle, {super.key});

  @override
  State<FormColorPickerField> createState() => _FormColorPickerFieldState();

  @override
  FormFieldValue<String> getValue() => FormFieldValue.string(value);

  @override
  bool isValid() {
    if (model.required == true && (value == null || value!.isEmpty)) {
      return false;
    }
    return true;
  }
}

class _FormColorPickerFieldState extends State<FormColorPickerField> {
  @override
  void initState() {
    super.initState();
    widget.value = widget.model.value as String?;
  }

  void _openPicker(StateManager stateManager) {
    final colors = widget.model.colors ?? _defaultColors;
    showDialog<Color>(
      context: context,
      builder: (ctx) => _ColorPickerDialog(
        colors: colors,
        selected: _fromHex(widget.value),
      ),
    ).then((picked) {
      if (picked == null) return;
      final hex = _toHex(picked);
      setState(() => widget.value = hex);
      stateManager.set(widget.model.tag, hex);
    });
  }

  @override
  Widget build(BuildContext context) {
    final stateManager = Provider.of<StateManager>(context, listen: false);
    final selectedColor = _fromHex(widget.value);

    return InkWell(
      onTap: widget.model.enableReadOnly == true
          ? null
          : () => _openPicker(stateManager),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: selectedColor ?? Colors.transparent,
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.value ?? (widget.model.value as String? ?? ''),
                style: widget.value != null
                    ? widget.formStyle.fieldTextStyle
                    : widget.formStyle.fieldHintStyle,
              ),
            ),
            Icon(Icons.colorize, color: Colors.grey.shade500, size: 20),
          ],
        ),
      ),
    );
  }
}

class _ColorPickerDialog extends StatefulWidget {
  final List<Color> colors;
  final Color? selected;

  const _ColorPickerDialog({required this.colors, this.selected});

  @override
  State<_ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<_ColorPickerDialog> {
  late Color? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16),
      content: SizedBox(
        width: 280,
        child: Wrap(
          key: const Key('color_palette'),
          spacing: 8,
          runSpacing: 8,
          children: widget.colors.map((color) {
            final isSelected = _selected?.toARGB32() == color.toARGB32();
            return GestureDetector(
              onTap: () => setState(() => _selected = color),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color,
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey.shade400,
                    width: isSelected ? 2.5 : 1,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: isSelected
                    ? Icon(
                        Icons.check,
                        size: 18,
                        color: color.computeLuminance() > 0.5
                            ? Colors.black
                            : Colors.white,
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _selected != null
              ? () => Navigator.of(context).pop(_selected)
              : null,
          child: const Text('Select'),
        ),
      ],
    );
  }
}
