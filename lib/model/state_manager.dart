import 'package:flutter/cupertino.dart';

class StateManager extends ChangeNotifier {
  final Map<String, dynamic> _state = {};

  void set(String key, dynamic value) {
    _state[key] = value;
    notifyListeners();
  }

  dynamic get(String? key) {
    if (key == null) return null;

    return _state[key];
  }
}
