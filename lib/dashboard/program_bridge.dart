/*
-------------------------------------------------------------------------------
    Copyright (c) Charles Carley.

  This software is provided 'as-is', without any express or implied
  warranty. In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.
-------------------------------------------------------------------------------
*/
import 'package:flutter/material.dart';
import 'package:waterpark_frontend/state/node.dart';
import '../state/tank.dart';
import 'tank.dart';

class ProgramStreamBridge extends StatefulWidget {
  final NodeManager manager;

  const ProgramStreamBridge({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  State<ProgramStreamBridge> createState() => _ProgramStreamBridgeState();
}

class _ProgramStreamBridgeState extends State<ProgramStreamBridge> {
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

  Node? _peekNode(int offset) {
    int location = _cur + offset;
    if (location < 0 || location >= _nodes.length) {
      return null;
    }
    return _nodes[location];
  }

  List<Widget> _construct(List<Node> nodes) {
    List<Widget> widgetList = [];

    _nodes = nodes;

    for (_cur = 0; _cur < _nodes.length; ++_cur) {
      Node node = _nodes[_cur];

      if (node is Tank) {
        widgetList.add(TankWidget(state: node));
      } else if (node is Sock) {
        Rect rct = Rect.fromLTRB(0, 0, 5, 5);
        Node? nd = _peekNode(-1);

        if (nd != null) {
          if (nd is Tank) {
            Tank prev = nd;
            rct = Rect.fromLTRB(
              prev.x,
              prev.y,
              100,
              100,
            );
            widgetList.add(SocketWidget(
              state: node,
              rect: rct,
            ));
          }
        }
      }
    }

    if (widgetList.isEmpty) {
      widgetList.add(Center());
    }
    List<Widget> ret = [];
    for (var node in widgetList )
    {
      ret.add(node);
    }
    return ret;
  }
}
