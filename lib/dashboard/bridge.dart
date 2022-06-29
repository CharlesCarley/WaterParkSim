import 'package:flutter/material.dart';
import 'package:waterpark_frontend/dashboard/input.dart';
import 'package:waterpark_frontend/metrics.dart';
import 'package:waterpark_frontend/state/node.dart';
import '../state/input_object.dart';
import '../state/socket_object.dart';
import '../state/tank_object.dart';
import 'socket.dart';
import 'tank.dart';

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

  Location? lastPosition() {
    for (int i = _cur; i >= 0; --i) {
      if (_nodes[i] is Location) {
        return _nodes[i] as Location;
      }
    }
    return null;
  }

  void _addSocket(
      List<Widget> widgetList, SockObject sock, double x, double y) {
    if ((sock.dir & SocketBits.S) != 0) {
      y = y + (Metrics.tankHeight - Metrics.border);
    }
    if ((sock.dir & SocketBits.E) != 0) {
      x = x + (Metrics.tankWidth - Metrics.border);
    }
    widgetList.add(SocketWidget(
      state: sock,
      rect: Rect.fromLTWH(
          x + sock.dx, y + sock.dy, Metrics.border, Metrics.border),
    ));
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
    List<Widget> ret = [];
    for (var node in widgetList) {
      ret.add(node);
    }
    return ret;
  }

  void constructSocket(List<Widget> widgetList, SockObject node) {
    Location? loc = lastPosition();

    if (loc != null) {
      _addSocket(widgetList, node, loc.x, loc.y);
    } else {
      _addSocket(widgetList, node, 0, 0);
    }
  }

  void constructInput(List<Widget> widgetList, InputObject node) {
    Location? loc = lastPosition();

    if (loc != null) {
      widgetList.add(InputWidget(
        state: node,
        rect: Rect.fromLTWH(
          node.x + loc.x,
          node.y + loc.y,
          30,
          10,
        ),
      ));
    } else {
      widgetList.add(InputWidget(
        state: node,
        rect: Rect.fromLTWH(
          node.x,
          node.y,
          30,
          10,
        ),
      ));
    }
  }
}
