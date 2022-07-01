import 'package:flutter/material.dart';
import '../palette.dart';
import '../state/settings_state.dart';
import '../state/state_manager.dart';
import '../widgets/positioned_widgets.dart';
import 'program_canvas.dart';
import 'program_editor.dart';
import 'widgets/action_widget.dart';
import 'widgets/event_router.dart';
import 'widgets/icon_widget.dart';
import 'widgets/split_widget.dart';

class WaterParkSimulator extends StatefulWidget {
  const WaterParkSimulator({Key? key}) : super(key: key);

  @override
  State<WaterParkSimulator> createState() => _WaterParkSimulatorState();
}

class _WaterParkSimulatorState extends State<WaterParkSimulator>
    with WorkSpaceEventReceiver {
  WorkspaceEventDispatcher dispatcher = WorkspaceEventDispatcher();
  GlobalKey scaffolding = GlobalKey();

  bool showSettings = false;
  Size _size = Size.zero;

  @override
  void dispose() {
    dispatcher.unsubscribe(this);
    super.dispose();
  }

  @override
  void initState() {
    dispatcher.subscribe(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WaterPark Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Palette.background),
        canvasColor: Palette.canvasColor,
      ),
      home: Scaffold(
        key: scaffolding,
        appBar: AppBar(
          foregroundColor: Palette.titleForeground,
          backgroundColor: Palette.titleBackground,
          title: Text(SettingsState.title),
          actions: _buildActionList(),
        ),
        body: Stack(
          children: _buildBody(),
        ),
      ),
    );
  }

  List<Widget> _buildBody() {
    List<Widget> body = [
      SplitWidget(
        initialSplit: 0.25,
        direction: SplitWidgetDirection.vertical,
        childA: ProgramEditor(
          manager: dispatcher,
          program: SettingsState.debugProg,
        ),
        childB: ProgramCanvas(
          dispatcher: dispatcher,
        ),
      )
    ];

    if (showSettings) {
      body.add(
        PositionedColoredBox(
          rect: Rect.fromLTWH(
            0,
            0,
            _size.width,
            _size.height,
          ),
          color: Palette.action,
        ),
      );
    }
    return body;
  }

  List<Widget> _buildActionList() {
    return [
      ActionIcon.tool(
        icon: IconMappings.play,
        x: 0,
        y: 0,
        onClick: () {
          setState(() {
            dispatcher.notifyRun();
          });
        },
        tooltip: "",
      ),
      ActionIcon.tool(
        icon: IconMappings.edit,
        x: 0,
        y: 0,
        onClick: () {
          setState(() {
            dispatcher.notifyDisplaySettings();
          });
        },
        tooltip: "",
      ),
    ];
  }

  @override
  void onDisplaySettings() {
    setState(() {
      if (scaffolding.currentContext != null) {
        _size = MediaQuery.of(scaffolding.currentContext!).size;
      }
      showSettings = true;
    });
  }

  @override
  void onRun() {
    setState(() {});
  }

  @override
  void onStateTreeCompiled(StateTree stateTree) {
    setState(() {});
  }
}
