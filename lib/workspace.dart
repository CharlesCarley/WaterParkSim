import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waterpark_frontend/metrics.dart';
import 'package:waterpark_frontend/theme.dart';
import 'package:waterpark_frontend/workspace_settings.dart';
import '../palette.dart';
import '../state/settings_state.dart';
import '../state/state_manager.dart';
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
  late FocusNode keyFocus;

  @override
  void dispose() {
    dispatcher.unsubscribe(this);
    super.dispose();
  }

  @override
  void initState() {
    keyFocus = FocusNode();
    keyFocus.requestFocus();

    dispatcher.subscribe(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: SettingsState.title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Palette.background),
        canvasColor: Palette.canvasColor,
        textButtonTheme: WorkspaceTheme.textButtonTheme,
      ),
      home: RawKeyboardListener(
        focusNode: keyFocus,
        autofocus: false,
        onKey: (key) => dispatcher.notifyKey(key),
        child: Scaffold(
          key: scaffolding,
          appBar: AppBar(
            toolbarHeight: 36,
            foregroundColor: Palette.titleForeground,
            backgroundColor: Palette.titleBackground,
            title: Text(
              SettingsState.title,
              style: Common.sizedTextStyle(18),
            ),
            actions: _buildActionList(),
          ),
          body: Stack(
            children: _buildBody(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBody() {
    List<Widget> body = [];

    if (showSettings) {
      body.add(
        WorkspaceSettings(
          dispatcher: dispatcher,
          rect: Rect.fromLTWH(0, 0, _size.width, _size.height),
        ),
      );
    } else {
      body.add(SplitWidget(
        initialSplit: 0.25,
        direction: SplitWidgetDirection.vertical,
        childA: ProgramEditor(
          dispatcher: dispatcher,
          program: SettingsState.debugProg,
        ),
        childB: ProgramCanvas(
          dispatcher: dispatcher,
        ),
      ));
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
          dispatcher.notifyRun();
        },
        tooltip: "Runs a simulation with the current script.",
      ),
      ActionIcon.tool(
        icon: IconMappings.edit,
        x: 0,
        y: 0,
        onClick: () {
          dispatcher.notifyDisplaySettings();
        },
        tooltip: "Opens the settings panel.",
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
      keyFocus.requestFocus();
    });
  }

  @override
  void onDisplaySettingsClosed() {
    setState(() {
      showSettings = false;
      keyFocus.requestFocus();
    });
  }

  @override
  void onStateTreeCompiled(StateTree stateTree) {
    setState(() {
      keyFocus.unfocus();
    });
  }

  @override
  void onKey(RawKeyEvent key) {
    if (showSettings) {
      if (key.physicalKey == (PhysicalKeyboardKey.escape)) {
        setState(() {
          showSettings = false;
          keyFocus.unfocus();
        });
      }
    } else {
      if (key.isControlPressed &&
          key.physicalKey == (PhysicalKeyboardKey.keyE)) {
        setState(() {
          showSettings = true;
          keyFocus.requestFocus();
        });
      }
    }
  }
}
