import 'package:flutter/material.dart';
import '../dashboard/input_widget.dart';
import '../dashboard/pump_widget.dart';
import '../dashboard/socket_widget.dart';
import '../dashboard/tank_widget.dart';
import '../state/object_state.dart';
import '../state/input_state.dart';
import '../state/pump_state.dart';
import '../state/settings_state.dart';
import '../state/socket_state.dart';
import '../state/tank_state.dart';
import '../dashboard/link_widget.dart';
import 'simulation/state_execute.dart';

class ProgramCanvasConstructor {
  final StateTreeExecutor tree;
  late List<Widget> widgets;

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
      y = y + (h - Settings.border);
    }
    if ((sock.dir & SocketBits.E) != 0) {
      x = x + (w - Settings.border);
    }
    sock.ax = x + sock.dx + Settings.border * 0.5;
    sock.ay = y + sock.dy + Settings.border * 0.5;

    widgetList.add(
      SocketWidget(
        state: sock,
        rect: Rect.fromLTWH(
          x + sock.dx,
          y + sock.dy,
          Settings.border,
          Settings.border,
        ),
      ),
    );

    if (sock.link != null) {
      SockObject linked = sock.link!;
      widgetList.add(LinkWidget(from: sock, to: linked));
    }
  }

  List<Widget> _construct() {
    List<Widget> widgetList = [];

    for (var cur = 0; cur < tree.code.length; ++cur) {
      SimObject node = tree.code[cur];
      if (node is TankObject) {
        widgetList.add(TankWidget(state: node));
      } else if (node is SockObject) {
        _constructSocket(widgetList, node);
      } else if (node is InputObject) {
        _constructInput(widgetList, node);
      } else if (node is PumpObject) {
        _constructPump(widgetList, node);
      }
    }

    if (widgetList.isEmpty) {
      widgetList.add(const Center());
    }

    return widgetList;
  }

  void _constructSocket(List<Widget> widgetList, SockObject node) {
    SimNode loc = node.parent;
    _addSocket(widgetList, node, loc.x, loc.y, loc.w, loc.h);
  }

  void _constructInput(List<Widget> widgetList, InputObject node) {
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

  void _constructPump(List<Widget> widgetList, PumpObject node) {
    widgetList.add(PumpWidget(
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
