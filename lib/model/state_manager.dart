import 'package:flutter/cupertino.dart';
import 'package:data_forms/rules/rules_engine.dart';

class StateManager extends ChangeNotifier {
  final Map<String, dynamic> _state = {};

  /// Optional rules engine injected by [DataForm].
  RulesEngine? rulesEngine;

  void set(String key, dynamic value) {
    _state[key] = value;
    notifyListeners();
  }

  dynamic get(String? key) {
    if (key == null) return null;
    return _state[key];
  }

  /// Returns `true` when the field or section identified by [tag] should be
  /// visible according to the current rules and form state.
  ///
  /// Returns `true` when no [rulesEngine] is configured.
  bool isVisible(String tag) {
    if (rulesEngine == null) return true;
    return rulesEngine!.isVisible(tag, (key) => _state[key]);
  }
}
