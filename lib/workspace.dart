import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waterpark/metrics.dart';
import 'package:waterpark/theme.dart';
import 'package:waterpark/workspace_settings.dart';
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

  final WorkspaceEventDispatcher _dispatcher = WorkspaceEventDispatcher();
  final GlobalKey scaffolding = GlobalKey();

  late bool _showSettings;
  late Size _size;
  late FocusNode _keyFocus;

  @override
  void initState() {
    _keyFocus = FocusNode();
    _keyFocus.requestFocus();
    _dispatcher.subscribe(this);
    _showSettings = false;
    _size = Size.zero;

    super.initState();
  }


  @override
  void dispose() {
    _dispatcher.unsubscribe(this);
    super.dispose();
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
        focusNode: _keyFocus,
        autofocus: false,
        onKey: (key) => _dispatcher.notifyKey(key),
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

    if (_showSettings) {
      body.add(
        WorkspaceSettings(
          dispatcher: _dispatcher,
          rect: Rect.fromLTWH(0, 0, _size.width, _size.height),
        ),
      );
    } else {
      body.add(SplitWidget(
        initialSplit: 0.25,
        direction: SplitWidgetDirection.vertical,
        childA: ProgramEditor(
          dispatcher: _dispatcher,
          program: SettingsState.debugProg,
        ),
        childB: ProgramCanvas(
          dispatcher: _dispatcher,
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
          _dispatcher.notifyRun();
        },
        tooltip: "Runs a simulation with the current script.",
      ),
      ActionIcon.tool(
        icon: IconMappings.edit,
        x: 0,
        y: 0,
        onClick: () {
          _dispatcher.notifyDisplaySettings();
        },
        tooltip: "Opens the settings panel. (Ctrl + E)",
      ),
    ];
  }

  @override
  void onDisplaySettings() {
    setState(() {
      if (scaffolding.currentContext != null) {
        _size = MediaQuery.of(scaffolding.currentContext!).size;
      }
      _showSettings = true;
      _keyFocus.requestFocus();
    });
  }

  @override
  void onDisplaySettingsClosed() {
    setState(() {
      _showSettings = false;
      _keyFocus.requestFocus();
    });
  }

  @override
  void onStateTreeCompiled(StateTree stateTree) {
    setState(() {
      _keyFocus.unfocus();
    });
  }

  @override
  void onKey(RawKeyEvent key) {
    if (_showSettings) {
      if (key.physicalKey == (PhysicalKeyboardKey.escape)) {
        setState(() {
          _showSettings = false;
          _keyFocus.unfocus();
        });
      }
    } else {
      if (key.isControlPressed &&
          key.physicalKey == (PhysicalKeyboardKey.keyE)) {
        setState(() {
          _showSettings = true;
          _keyFocus.requestFocus();
        });
      }
    }
  }
}
