import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:waterpark_frontend/dashboard/input.dart';
import 'package:waterpark_frontend/metrics.dart';
import 'package:waterpark_frontend/palette.dart';
import 'package:waterpark_frontend/state/common_state.dart';
import 'package:waterpark_frontend/widgets/positioned_widgets.dart';
import '../state/input_state.dart';
import '../state/rect_state.dart';
import '../state/socket_state.dart';
import '../state/state_manager.dart';
import '../state/tank_state.dart';
import 'link.dart';
import 'socket.dart';
import 'tank.dart';

class MathUtil {
  static double min(double a, double b) {
    return a < b ? a : b;
  }

  static double max(double a, double b) {
    return a > b ? a : b;
  }
}

class ProgramCanvas extends StatefulWidget {
  final NodeManager manager;

  const ProgramCanvas({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  State<ProgramCanvas> createState() => _ProgramCanvasState();
}

class _ProgramCanvasState extends State<ProgramCanvas> {
  List<Node> _nodes = [];
  int _cur = 0;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: widget.manager.clearColor,
      child: Stack(
        children: _construct(widget.manager.fetch()),
      ),
    );
  }

  RectState? lastPosition() {
    for (int i = _cur; i >= 0; --i) {
      if (_nodes[i] is RectState) {
        return _nodes[i] as RectState;
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
      List<SockObject> osock = sock.getOutputs();

      for (var link in osock) {
        widgetList.add(LinkWidget(
          state: sock,
          link: link,
        ));
      }
    }
  }

  List<Widget> _construct(List<Node> nodes) {
    List<Widget> widgetList = [];

    _nodes = nodes;

    for (_cur = 0; _cur < _nodes.length; ++_cur) {
      Node node = _nodes[_cur];

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
