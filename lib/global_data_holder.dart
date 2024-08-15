import 'package:flutter/material.dart';

class GlobalDataHolder {
  GlobalDataHolder._();

  ValueNotifier<ThemeMode> themeMode=ValueNotifier(ThemeMode.system);

  final Map<String, List<void Function()>> _simpleCallbacks = {};

  void registerSimpleCallback(String name, void Function() callback) {
    if (_simpleCallbacks.containsKey(name)) {
      _simpleCallbacks[name]!.add(callback);
    } else {
      _simpleCallbacks[name] = [ callback ];
    }
  }

  void unregisterSimpleCallback(String name, void Function() callback) {
    _simpleCallbacks[name]?.remove(callback);
  }

  void invokeSimpleCallback(String name) {
    for (final callback in _simpleCallbacks[name] ?? []) {
      callback();
    }
  }

  static GlobalDataHolder? _instance;
  static GlobalDataHolder get instance {
    _instance ??= GlobalDataHolder._();
    return _instance!;
  }
}