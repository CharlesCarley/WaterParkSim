import 'dart:collection';

import 'package:flutter/widgets.dart';

import '../util/stack.dart';
import 'object_state.dart';

class SocketBits {
  static const int N = 0x01;
  static const int E = 0x02;
  static const int S = 0x04;
  static const int W = 0x08;
}

class SockObject extends SimObject {
  final int dir;
  final double dx;
  final double dy;
  final SimNode parent;
  final int target;
  double ax = 0;
  double ay = 0;
  SockObject? link;
  final List<SockObject> fromLinks = [];
  final Queue<double> _cache = Queue();

  VoidCallback? onChange;

  SockObject({
    required this.dir,
    required this.dx,
    required this.dy,
    required this.parent,
    required this.target,
    VoidCallback? change,
  }) : onChange = change;

  double popCache() {
    if (_cache.isNotEmpty) {
      onChange?.call();
      var v = _cache.removeLast();
      return v;
    }
    return 0;
  }

  double peekCache() {
    if (_cache.isNotEmpty) return _cache.last;
    return 0;
  }

  void cacheValue(double v) {
    _cache.add(v);
    onChange?.call();
  }

  void connect(SockObject obj) {
    link = obj;
    obj.fromLinks.add(this);
  }
}
