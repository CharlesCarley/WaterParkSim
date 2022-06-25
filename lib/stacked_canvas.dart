import 'package:flutter/material.dart';

import 'metrics.dart';
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
      14,
      13,
      12,
      11,
      10,
      9,
      8,
      7,
      6,
      5,
      4,
      3,
      2,
      1,
      0
    ];

    List<Widget> ret = [];
    double x = 20;
    double y = 20;

    const int maxPerLine = 5;
    int perLine = 0;

    for (var d in statList) {
      ret.add(TankWidget(x, y, 20, d));
      x += Metrics.tankWidth + 50;
      ++perLine;

      if (perLine > maxPerLine) {
        y += Metrics.tankHeight + 10;
        perLine = 0;
        x = 20;
      }
    }
    return ret;
  }
}
