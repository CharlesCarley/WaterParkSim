import 'package:flutter/material.dart';
import 'package:waterpark_frontend/palette.dart';

class Node {}

class NodeManager extends Listenable {
  List<Node> _values = [];
  VoidCallback? onValueChanged;

  get clearColor => Palette.background;

  void apply(List<Node> evt){
    _values.clear();
    _values = evt;
    onValueChanged?.call();
  }

  List<Node> fetch() {
    return _values;
  }

  @override
  void addListener(VoidCallback listener) {
    onValueChanged = listener;
  }

  @override
  void removeListener(VoidCallback listener) {
    onValueChanged = null;
  }
}
