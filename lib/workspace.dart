import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'metrics.dart';
import 'theme.dart';
import 'workspace_help.dart';
import 'workspace_settings.dart';
import '../palette.dart';
import '../state/settings_state.dart';
import '../state/state_manager.dart';
import 'program_canvas.dart';
import 'program_editor.dart';
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

  late bool _showSettings, _showHelp;
  late Size _size;
  late FocusNode _keyFocus;

  @override
  void initState() {
    _keyFocus = FocusNode();
    _keyFocus.requestFocus();
    _dispatcher.subscribe(this);
    _showSettings = false;
    _showHelp = false;
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Palette.background,
        ),
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
          body: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_showHelp) {
      return WorkspaceHelp(
        dispatcher: _dispatcher,
        rect: Rect.fromLTWH(0, 0, _size.width, _size.height),
      );
    } else if (_showSettings) {
      return WorkspaceSettings(
        dispatcher: _dispatcher,
        rect: Rect.fromLTWH(0, 0, _size.width, _size.height),
      );
    } else {
      List<Widget> body = [];
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
      return Stack(children: body);
    }
  }

  List<Widget> _buildActionList() {
    return [
      IconWidget.tool(
        icon: IconMappings.play,
        onClick: () {
          _dispatcher.notifyRun();
        },
        tooltip: "Runs a simulation with the current script.",
      ),
      IconWidget(
        icon: IconMappings.gears,
        onClick: () {
          _dispatcher.notifyDisplaySettings();
        },
        tooltip: "Opens the settings panel. (Ctrl+Shift+E)",
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
  void onHelpClosed() {
    setState(() {
      _showHelp = false;
      _keyFocus.requestFocus();
    });
  }

  @override
  void onHelp() {
    setState(() {
      _showHelp = true;
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
    if (_showHelp) {
      if (key.physicalKey == (PhysicalKeyboardKey.escape)) {
        setState(() {
          _showSettings = false;
          _showHelp = false;
          _keyFocus.requestFocus();
        });
      }
    } else if (_showSettings) {
      if (key.physicalKey == (PhysicalKeyboardKey.escape)) {
        setState(() {
          _showSettings = false;
          _showHelp = false;
          _keyFocus.requestFocus();
        });
      }
    } else {
      if (key.isControlPressed &&
          key.isShiftPressed &&
          key.physicalKey == (PhysicalKeyboardKey.keyE)) {
        setState(() {
          _showSettings = true;
          _keyFocus.requestFocus();
        });
      }
    }
  }
}
