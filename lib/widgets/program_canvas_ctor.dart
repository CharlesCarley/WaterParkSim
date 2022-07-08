import 'package:flutter/material.dart';
import 'package:waterpark/dashboard/input_widget.dart';
import 'package:waterpark/dashboard/socket_widget.dart';
import 'package:waterpark/dashboard/tank_widget.dart';
import '../state/object_state.dart';
import '../state/input_state.dart';
import '../state/settings_state.dart';
import '../state/socket_state.dart';
import '../state/state_tree.dart';
import '../state/tank_state.dart';
import '../dashboard/link_widget.dart';

class ProgramCanvasConstructor {
  final StateTree tree;
  late List<Widget> widgets;
  int _cur = 0;

  ProgramCanvasConstructor({required this.tree}) {
    widgets = _construct();
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
      y = y + (h - SettingsState.border);
    }
    if ((sock.dir & SocketBits.E) != 0) {
      x = x + (w - SettingsState.border);
    }
    sock.ax = x + sock.dx + SettingsState.border / 2;
    sock.ay = y + sock.dy + SettingsState.border / 2;

    widgetList.add(SocketWidget(
      state: sock,
      rect: Rect.fromLTWH(
        x + sock.dx,
        y + sock.dy,
        SettingsState.border,
        SettingsState.border,
      ),
    ));

    if (sock.link != null) {
      SockObject linked = sock.link!;
      widgetList.add(LinkWidget(
        state: sock,
        link: linked,
      ));
    }
  }

  List<Widget> _construct() {
    List<Widget> widgetList = [];

    for (_cur = 0; _cur < tree.code.length; ++_cur) {
      SimObject node = tree.code[_cur];
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
    SimNode loc = node.parent;
    _addSocket(widgetList, node, loc.x, loc.y, loc.w, loc.h);
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
