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

import '../metrics.dart';
import 'tank.dart';

////////////////////////////////////////////////////////////////
class StackedCanvas extends StatefulWidget {
  const StackedCanvas({Key? key}) : super(key: key);

  @override
  State<StackedCanvas> createState() => _StackedCanvasState();
}

class _StackedCanvasState extends State<StackedCanvas> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(0xFF, 0x1B, 0x1B, 0x1B),
      body: Stack(children: getChildren()),
    );
  }

  List<Widget> getChildren() {
    List<double> statList = [
      20,
      19,
      18,
      17,
      16,
      15,
    ];

    List<Widget> ret = [];
    double x = 20;
    double y = 200;

    const int maxPerLine = 5;
    int perLine = 0;

    for (var d in statList) {
      ret.add(TankWidget(x, y, 20, d));
      x += Metrics.tankWidth + 50;
      ++perLine;

      if (perLine > maxPerLine) {
        y += Metrics.tankHeight + 10;
        perLine = 0;
        x = 200;
      }
    }
    return ret;
  }
}

class StreamedCanvasBlock {
  List<String> _data = ["tank", "20", "20", "20", "15"];

  Stream<List<String>> get fetch async* {
    yield _data;
  }

  void push(String v) {
    _data.add(v);
  }
}

class StringStack {
  late List<String> _stack;

  StringStack() {
    _stack = [];
  }
  StringStack.fromList(List<String> list) {
    _stack = [];
    for (var i in list) {
      _stack.add(i);
    }
  }

  void push(String v) => _stack.add(v);
  void pop() => _stack.removeLast();

  String top() => _stack.last;
  bool empty() => _stack.isEmpty;

  int size() => _stack.length;

  String popTop() {
    String v = _stack.last;
    pop();
    return v;
  }
}

class StreamedCanvas extends StatelessWidget {
  StreamedCanvasBlock canvasBlock = StreamedCanvasBlock();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: canvasBlock.fetch,
      builder: (context, stream) {
        if (stream.hasData) {
          var list = (stream.data as List<String>);
          return Stack(
            children: _construct(StringStack.fromList(list)),
          );
        }
        return const Center();
      },
    );
  }

  List<Widget> _construct(StringStack strings) {
    List<Widget> widgetList = [];

    StringStack workingStack = StringStack();

    while (strings.size() > 0) {
      String v = strings.popTop();

      if (v == "tank") {
        if (workingStack.size() >= 4) {
          double x = double.tryParse(workingStack.popTop()) ?? 0;
          double y = double.tryParse(workingStack.popTop()) ?? 0;
          double h = double.tryParse(workingStack.popTop()) ?? 0;
          double l = double.tryParse(workingStack.popTop()) ?? 0;

          widgetList.add(TankWidget(x, y, h, l));
        }
      } else {
        workingStack.push(v);
      }
    }

    return widgetList;
  }
}
