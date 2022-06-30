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
import 'package:waterpark_frontend/widgets/texteditor.dart';
import 'dashboard/bridge.dart';
import 'palette.dart';
import 'widgets/icon.dart';
import 'widgets/split_widget.dart';

String debugProg = """
input 0 10 4
 state 1
 sock SE 0 25
tank 100 10 20 500 0
 sock NW 0 45
 link -1 -3
 sock SE 0 25
tank 250 10 20 500 5
 sock SW 0 25
 link -1 -3
 sock SE 0 34
input 350 110 0
 state 0
 sock NW 0 20
 link -1 -3
 sock NE 0 20
 sock NE -100 20
 link -1 -2
 sock NE -100 100
 link -1 -2
 sock SW -300 -55
 link -1 -2
 sock SW -300 -200
 link -1 -2
tank 100 300 20 500 15
 sock N 0 56
 link -1 -3
 sock NE 0 35
input 350 400 0
 state off
 sock NW 0 25
 link -1 -3
 sock NE 0 25
 sock NE -100 25
 link -1 -2
""";

void main() {
  runApp(const WaterParkSimulator());
}

class WaterParkSimulator extends StatefulWidget {
  const WaterParkSimulator({Key? key}) : super(key: key);

  @override
  State<WaterParkSimulator> createState() => _WaterParkSimulatorState();
}

class _WaterParkSimulatorState extends State<WaterParkSimulator> {
  final NodeManager manager = NodeManager();
  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    manager.addListener(() {
      setState(() {});
    });
    manager.onSimChanged = () {
      setState(() {});
    };

    return MaterialApp(
      title: 'WaterPark Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Palette.background),
        canvasColor: Palette.canvasColor,
      ),
      home: Scaffold(
        appBar: AppBar(
          foregroundColor: Palette.titleForeground,
          backgroundColor: Palette.titleBackground,
          title: const Text("WaterPark"),
          actions: [
            ActionIcon.tool(
              icon: IconMappings.play,
              x: 0,
              y: 0,
              color: Palette.titleForeground,
              onClick: () {
                manager.launchSim();
              },
              tooltip: "Run the simulation.",
            )
          ],
        ),
        body: SplitWidget(
          initialSplit: 0.25,
          direction: SplitWidgetDirection.vertical,
          childA: ProgramEditor(
            manager: manager,
            program: debugProg,
          ),
          childB: ProgramCanvas(
            key: _globalKey,
            manager: manager,
          ),
        ),
      ),
    );
  }
}
