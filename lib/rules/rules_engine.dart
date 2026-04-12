import 'package:data_forms/rules/form_rule.dart';

/// Evaluates [FormRule]s against the current form state to determine
/// whether fields and sections should be visible.
///
/// The engine is stateless — it receives values via a getter function so it
/// avoids any circular dependency with [StateManager].
class RulesEngine {
  final List<FormRule> rules;

  const RulesEngine({required this.rules});

  /// Returns a new engine that also includes [additional] rules.
  RulesEngine addRules(List<FormRule> additional) {
    return RulesEngine(rules: [...rules, ...additional]);
  }

  /// Whether the field/section identified by [tag] should be visible,
  /// given the current values provided by [getValue].
  ///
  /// Visibility semantics:
  /// 1. If no rules target [tag] → visible.
  /// 2. **show** rules: the target starts hidden; becomes visible when at
  ///    least one show-rule's conditions are satisfied.
  /// 3. **hide** rules: the target starts visible; becomes hidden when any
  ///    hide-rule's conditions are satisfied. Hide rules override show rules.
  bool isVisible(String tag, dynamic Function(String key) getValue) {
    final applicableRules = rules.where((r) => r.target == tag).toList();
    if (applicableRules.isEmpty) return true;

    // --- show rules ---
    final showRules =
        applicableRules.where((r) => r.action == RuleAction.show).toList();
    if (showRules.isNotEmpty) {
      final anyShowMet = showRules.any((r) => _evaluateRule(r, getValue));
      if (!anyShowMet) return false;
    }

    // --- hide rules (override show) ---
    final hideRules =
        applicableRules.where((r) => r.action == RuleAction.hide).toList();
    for (final rule in hideRules) {
      if (_evaluateRule(rule, getValue)) return false;
    }

    return true;
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  bool _evaluateRule(FormRule rule, dynamic Function(String) getValue) {
    final results =
        rule.conditions.map((c) => _evaluateCondition(c, getValue)).toList();
    return rule.requireAll
        ? results.every((r) => r)
        : results.any((r) => r);
  }

  bool _evaluateCondition(
      RuleCondition condition, dynamic Function(String) getValue) {
    final rawValue = getValue(condition.fieldTag);
    final fieldValue = _extractComparableValue(rawValue);
    final conditionValue = condition.value;

    switch (condition.operator) {
      case RuleOperator.equals:
        return _equals(fieldValue, conditionValue);
      case RuleOperator.notEquals:
        return !_equals(fieldValue, conditionValue);
      case RuleOperator.contains:
        return _str(fieldValue).contains(_str(conditionValue));
      case RuleOperator.notContains:
        return !_str(fieldValue).contains(_str(conditionValue));
      case RuleOperator.greaterThan:
        return _compareNumeric(fieldValue, conditionValue) > 0;
      case RuleOperator.lessThan:
        return _compareNumeric(fieldValue, conditionValue) < 0;
      case RuleOperator.greaterThanOrEqual:
        return _compareNumeric(fieldValue, conditionValue) >= 0;
      case RuleOperator.lessThanOrEqual:
        return _compareNumeric(fieldValue, conditionValue) <= 0;
      case RuleOperator.isEmpty:
        return fieldValue == null || _str(fieldValue).isEmpty;
      case RuleOperator.isNotEmpty:
        return fieldValue != null && _str(fieldValue).isNotEmpty;
      case RuleOperator.isIn:
        final list =
            conditionValue is List ? conditionValue : [conditionValue];
        return list.any((v) => _equals(fieldValue, v));
      case RuleOperator.notIn:
        final list =
            conditionValue is List ? conditionValue : [conditionValue];
        return !list.any((v) => _equals(fieldValue, v));
    }
  }

  /// Normalises a field value to something comparable.
  ///
  /// For models that have an `id` field (e.g. SpinnerDataModel, RadioDataModel)
  /// the `id` is returned so rules can match against numeric IDs.
  /// Falls back to `name`, then `toString()`.
  static dynamic _extractComparableValue(dynamic value) {
    if (value == null) return null;
    if (value is String || value is num || value is bool) return value;

    // SpinnerDataModel / RadioDataModel / CheckDataModel — try .id
    try {
      // ignore: avoid_dynamic_calls
      final id = (value as dynamic).id;
      if (id != null) return id;
    } catch (_) {}

    // Try .name as fallback
    try {
      // ignore: avoid_dynamic_calls
      final name = (value as dynamic).name;
      if (name != null) return name;
    } catch (_) {}

    return value.toString();
  }

  bool _equals(dynamic a, dynamic b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a is num && b is num) return a == b;
    if (a is bool && b is bool) return a == b;
    // Cross-type numeric comparison (e.g. int 1 vs string "1")
    final aNum = num.tryParse(a.toString());
    final bNum = num.tryParse(b.toString());
    if (aNum != null && bNum != null) return aNum == bNum;
    return a.toString() == b.toString();
  }

  double _compareNumeric(dynamic a, dynamic b) {
    final aNum = num.tryParse(a?.toString() ?? '');
    final bNum = num.tryParse(b?.toString() ?? '');
    if (aNum == null || bNum == null) return 0;
    return (aNum - bNum).toDouble();
  }

  String _str(dynamic value) => value?.toString() ?? '';
}
