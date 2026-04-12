import 'package:flutter/material.dart';
import 'package:data_forms/core/form_style.dart';
import 'package:data_forms/model/state_manager.dart';
import 'package:data_forms/values/theme.dart';
import 'package:data_forms/widget/field.dart';
import 'package:data_forms/widget/fields/text_plain_field.dart';
import 'package:data_forms/widget/squircle/smooth_border_radius.dart';
import 'package:data_forms/widget/squircle/smooth_rectangle_border.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class FormSection extends StatelessWidget {
  late List<Widget> fields;
  FormStyle? style;
  String? sectionTitle;

  /// Optional identifier used by the rules engine to control this section's
  /// visibility. Leave `null` if visibility rules are not needed.
  String? tag;

  FormSection({
    super.key,
    required this.fields,
    this.style,
    required this.sectionTitle,
    this.tag,
  });

  @override
  Widget build(BuildContext context) {
    style = style ?? FormStyle();

    List<Row> rows = [];

    int i = 0; // while index on fields
    int weightSum = 0;

    while (i < fields.length) {
      if (fields[i] is DataFormField) {
        List<Widget> childrenAtRow = []; // children in each row
        while (weightSum < 12 && i <= fields.length - 1) {
          DataFormField field = fields[i] as DataFormField;
          childrenAtRow.add(
            Expanded(flex: field.model?.weight ?? 12, child: field),
          );

          weightSum += field.model?.weight ?? 12;
          if (i < fields.length - 1 &&
              fields[i + 1] is DataFormField &&
              fields[i + 1] is! FormTextPlainField) {
            field.model?.nextFocusNode =
                (fields[i + 1] as DataFormField).model?.focusNode;
          }
          field.formStyle = style!;
          i++;

          if (weightSum != 12) {
            childrenAtRow.add(const SizedBox(width: 12));
          }
        }
        rows.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: childrenAtRow,
          ),
        );
        weightSum = 0;
      } else {
        rows.add(Row(children: [Expanded(flex: 12, child: fields[i])]));
        i++;
      }
    }

    final sectionContent = Column(
      children: [
        sectionTitle != null
            ? Padding(
              padding: const EdgeInsetsDirectional.only(start: 4),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        sectionTitle!,
                        style:
                            style?.sectionTitleStyle ??
                            FormTheme.textThemeStyle.displayLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                ],
              ),
            )
            : Container(),
        Card(
          color: style?.backgroundSectionColor,
          elevation: style?.sectionCardElevation,
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius(
              cornerRadius: style!.sectionRadius,
              cornerSmoothing: 1,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: style!.sectionCardPadding,
              right: style!.sectionCardPadding,
              top: style!.sectionCardPadding,
              bottom: style!.sectionCardPadding,
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: rows.length,
              separatorBuilder: (context, index) => const SizedBox(height: 4.0),
              itemBuilder: (context, index) {
                return rows[index];
              },
            ),
          ),
        ),
      ],
    );

    // If no tag is set, render the section directly (no rule evaluation needed).
    if (tag == null) return sectionContent;

    // Otherwise wrap with a Consumer to react to rule changes smoothly.
    return Consumer<StateManager>(
      builder: (context, stateManager, _) {
        final isVisible = stateManager.isVisible(tag!);

        return AnimatedCrossFade(
          duration: const Duration(milliseconds: 280),
          sizeCurve: Curves.easeInOut,
          firstCurve: Curves.easeOut,
          secondCurve: Curves.easeIn,
          crossFadeState:
              isVisible ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: sectionContent,
          secondChild: const SizedBox.shrink(),
        );
      },
    );
  }
}
