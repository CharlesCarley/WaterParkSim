import 'package:flutter/material.dart';
import 'package:waterpark_frontend/dashboard/input.dart';
import 'package:waterpark_frontend/dashboard/socket.dart';
import 'package:waterpark_frontend/dashboard/tank.dart';
import 'package:waterpark_frontend/metrics.dart';

import '../state/common_state.dart';
import '../state/input_state.dart';
import '../state/rect_state.dart';
import '../state/socket_state.dart';
import '../state/state_manager.dart';
import '../state/tank_state.dart';
import 'link.dart';

class ProgramCanvasConstructor {
  final StateTree tree;
  late List<Widget> widgets;
  int _cur = 0;

  ProgramCanvasConstructor({required this.tree}) {
    widgets = _construct();
  }

  RectState? lastPosition() {
    for (int i = _cur; i >= 0; --i) {
      if (tree.code[i] is RectState) {
        return tree.code[i] as RectState;
      }
    }
    return null;
  }

  void _addSocket(
    List<Widget> widgetList,
    SockObject sock,
    double x,
    double y,
    double w,
    double h,
  ) {
    if ((sock.dir & SocketBits.S) != 0) {
      y = y + (h - Metrics.border);
    }
    if ((sock.dir & SocketBits.E) != 0) {
      x = x + (w - Metrics.border);
    }
    sock.ax = x + sock.dx + Metrics.border / 2;
    sock.ay = y + sock.dy + Metrics.border / 2;

    widgetList.add(SocketWidget(
      state: sock,
      rect: Rect.fromLTWH(
          x + sock.dx, y + sock.dy, Metrics.border, Metrics.border),
    ));

    if (sock.hasOutputs) {
      List<SockObject> oSock = sock.getOutputs();

      for (var link in oSock) {
        widgetList.add(LinkWidget(
          state: sock,
          link: link,
        ));
      }
    }
  }

  List<Widget> _construct() {
    List<Widget> widgetList = [];

    for (_cur = 0; _cur < tree.code.length; ++_cur) {
      Node node = tree.code[_cur];
      if (node is TankObject) {
        widgetList.add(TankWidget(state: node));
      } else if (node is SockObject) {
        constructSocket(widgetList, node);
      } else if (node is InputObject) {
        constructInput(widgetList, node);
      }
    }

    if (widgetList.isEmpty) {
      widgetList.add(const Center());
    }
    return widgetList;
  }

  void constructSocket(List<Widget> widgetList, SockObject node) {
    RectState? loc = lastPosition();

    if (loc != null) {
      _addSocket(widgetList, node, loc.x, loc.y, loc.w, loc.h);
    } else {
      _addSocket(widgetList, node, 0, 0, 1, 1);
    }
  }

  void constructInput(List<Widget> widgetList, InputObject node) {
    widgetList.add(InputWidget(
      state: node,
      rect: Rect.fromLTWH(
        node.x,
        node.y,
        node.w,
        node.h,
      ),
    ));
  }
}
