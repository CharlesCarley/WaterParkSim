import 'package:flutter/material.dart';
import 'dashboard/bridge.dart';
import 'palette.dart';
import 'state/common_state.dart';
import 'state/state_manager.dart';
import 'widgets/action_widget.dart';
import 'widgets/icon_widget.dart';
import 'widgets/split_widget.dart';
import 'widgets/program_editor.dart';

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
