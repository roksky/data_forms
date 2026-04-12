import 'dart:convert';

/// Operators for comparing a field's current value against a condition value.
enum RuleOperator {
  equals,
  notEquals,
  contains,
  notContains,
  greaterThan,
  lessThan,
  greaterThanOrEqual,
  lessThanOrEqual,
  isEmpty,
  isNotEmpty,
  isIn,
  notIn,
}

/// What happens to the target when the rule's conditions are satisfied.
enum RuleAction {
  /// Target is visible only while conditions are met.
  show,

  /// Target is hidden while conditions are met.
  hide,
}

/// A single field-value comparison that forms part of a [FormRule].
class RuleCondition {
  /// The tag of the field whose value is evaluated.
  final String fieldTag;

  /// How to compare [fieldTag]'s value.
  final RuleOperator operator;

  /// The reference value to compare against.
  ///
  /// - For [RuleOperator.isIn] / [RuleOperator.notIn]: pass a JSON array, e.g. `[1, 2, 3]`.
  /// - For [RuleOperator.isEmpty] / [RuleOperator.isNotEmpty]: this field is ignored.
  /// - For numeric comparisons: use a number or a numeric string.
  final dynamic value;

  const RuleCondition({
    required this.fieldTag,
    required this.operator,
    this.value,
  });

  Map<String, dynamic> toJson() => {
        'field': fieldTag,
        'operator': operator.name,
        if (value != null) 'value': value,
      };

  factory RuleCondition.fromJson(Map<String, dynamic> json) {
    return RuleCondition(
      fieldTag: json['field'] as String,
      operator: RuleOperator.values.firstWhere(
        (e) => e.name == json['operator'],
        orElse: () => RuleOperator.equals,
      ),
      value: json['value'],
    );
  }

  @override
  String toString() => toJson().toString();
}

/// A rule that controls the visibility of a field or section in the form.
///
/// ### JSON format (single rule)
/// ```json
/// {
///   "target": "company_name",
///   "conditions": [
///     { "field": "customer_type", "operator": "equals", "value": "business" }
///   ],
///   "require_all": true,
///   "action": "show"
/// }
/// ```
///
/// ### Visibility semantics
/// - **show** rules: the target is *hidden by default* and becomes visible only
///   when at least one matching `show` rule's conditions are met.
/// - **hide** rules: the target is *visible by default* and becomes hidden when
///   any `hide` rule's conditions are met. Hide rules take precedence over show rules.
class FormRule {
  /// The field tag or section tag this rule controls.
  final String target;

  /// The conditions to evaluate.
  final List<RuleCondition> conditions;

  /// `true`  → all conditions must be met (AND logic).
  /// `false` → any condition must be met (OR logic).
  final bool requireAll;

  /// What happens when conditions are satisfied.
  final RuleAction action;

  const FormRule({
    required this.target,
    required this.conditions,
    this.requireAll = true,
    this.action = RuleAction.show,
  });

  Map<String, dynamic> toJson() => {
        'target': target,
        'conditions': conditions.map((c) => c.toJson()).toList(),
        'require_all': requireAll,
        'action': action.name,
      };

  factory FormRule.fromJson(Map<String, dynamic> json) {
    return FormRule(
      target: json['target'] as String,
      conditions: (json['conditions'] as List<dynamic>)
          .map((c) => RuleCondition.fromJson(c as Map<String, dynamic>))
          .toList(),
      requireAll: json['require_all'] as bool? ?? true,
      action: RuleAction.values.firstWhere(
        (e) => e.name == json['action'],
        orElse: () => RuleAction.show,
      ),
    );
  }

  /// Deserialise a single rule from a JSON string.
  factory FormRule.fromString(String json) {
    return FormRule.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  /// Serialise this rule to a JSON string.
  String toRuleString() => jsonEncode(toJson());

  /// Deserialise a list of rules from a JSON array string.
  static List<FormRule> listFromString(String json) {
    final list = jsonDecode(json) as List<dynamic>;
    return list
        .map((e) => FormRule.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Serialise a list of rules to a JSON array string.
  static String listToString(List<FormRule> rules) {
    return jsonEncode(rules.map((r) => r.toJson()).toList());
  }

  @override
  String toString() => toJson().toString();
}
