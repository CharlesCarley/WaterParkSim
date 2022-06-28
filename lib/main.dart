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
import 'dashboard/program_bridge.dart';
import 'palette.dart';
import 'widgets/icon.dart';
import 'widgets/workspace.dart';

void main() {
  runApp(WaterPark());
}

class WaterPark extends StatefulWidget {
  const WaterPark({Key? key}) : super(key: key);

  @override
  State<WaterPark> createState() => _WaterParkState();
}

class _WaterParkState extends State<WaterPark> {
  final NodeManager manager = NodeManager();

  @override
  Widget build(BuildContext context) {
    manager.addListener(() {
      setState(() {});
    });

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
            IconWidget(
              icon: IconMappings.play,
              x: 0,
              y: 0,
              color: Palette.titleForeground,
              onClick: () {},
              tooltip: "Run the simulation.",
            )
          ],
        ),
        body: SplitWidget(
          initialSplit: 0.25,
          direction: SplitWidgetDirection.vertical,
          childA: EditProgram(
            manager: manager,
            program: "tank 20 20 20 200 5",
          ),
          childB: ProgramStreamBridge(
            manager: manager,
          ),
        ),
      ),
    );
  }
}
