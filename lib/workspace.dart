import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waterpark/simulation/run_canvas.dart';
import 'metrics.dart';
import 'theme.dart';
import 'tokenizer/sim_builder.dart';
import 'widgets/compile_log.dart';
import 'workspace_help.dart';
import 'workspace_settings.dart';
import '../palette.dart';
import '../state/settings_state.dart';
import 'state/state_tree.dart';
import 'program_canvas.dart';
import 'program_editor.dart';
import 'widgets/event_router.dart';
import 'widgets/icon_widget.dart';
import 'widgets/split_widget.dart';

class WaterParkSimulator extends StatefulWidget {
  final WorkspaceEventDispatcher dispatcher;
   
  const WaterParkSimulator({required this.dispatcher, Key? key}) : super(key: key);

  @override
  State<WaterParkSimulator> createState() => _WaterParkSimulatorState();
}

class _WaterParkSimulatorState extends State<WaterParkSimulator>
    with WorkSpaceEventReceiver {
  final GlobalKey scaffolding = GlobalKey(debugLabel: "Scaffold");

  late bool _showSettings, _showHelp, _runScreen;
  late Size _size;
  late FocusNode _keyFocus;

  @override
  void initState() {
    _keyFocus = FocusNode();
    widget.dispatcher.subscribe(this);
    _showSettings = false;
    _showHelp = false;
    _runScreen = false;
    _size = Size.zero;

    super.initState();
    _focus();
  }

  @override
  void dispose() {
    widget.dispatcher.unsubscribe(this);
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
        onKey: (key) => widget.dispatcher.notifyKey(key),
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
    if (_runScreen) {
      return RunProgramCanvas(
        dispatcher: widget.dispatcher,
        tree: _compileCurrent(),
      );
    } else if (_showHelp) {
      return WorkspaceHelp(
        dispatcher: widget.dispatcher,
        rect: Rect.fromLTWH(0, 0, _size.width, _size.height),
      );
    } else if (_showSettings) {
      return WorkspaceSettings(
        dispatcher: widget.dispatcher,
        rect: Rect.fromLTWH(0, 0, _size.width, _size.height),
      );
    } else {
      List<Widget> body = [];
      body.add(SplitWidget(
        initialSplit: SettingsState.sashPos,
        direction: SplitWidgetDirection.vertical,
        childA: ProgramEditor(
          dispatcher: widget.dispatcher,
          program: SettingsState.debugProg,
        ),
        childB: ProgramCanvas(
          dispatcher: widget.dispatcher,
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
          widget.dispatcher.notifyRun();
        },
        tooltip: "Runs a simulation with the current script.",
      ),
      IconWidget(
        icon: IconMappings.gears,
        onClick: () {
          widget.dispatcher.notifyDisplaySettings();
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
      _focus();
    });
  }

  @override
  void onDisplaySettingsClosed() {
    setState(() {
      _showSettings = false;
      _focus();
    });
  }

  @override
  void onHelpClosed() {
    setState(() {
      _showHelp = false;
      _focus();
    });
  }

  @override
  void onHelp() {
    setState(() {
      _showHelp = true;
      _focus();
    });
  }

  @override
  void onStateTreeCompiled(StateTree stateTree) {
    setState(() {});
  }

  @override
  void onKey(RawKeyEvent key) {
    bool canEscExit = _showHelp || _showSettings || _runScreen;

    if (canEscExit) {
      if (key.physicalKey == (PhysicalKeyboardKey.escape)) {
        setState(() {
          _showSettings = false;
          _showHelp = false;
          _runScreen = false;
          _focus();
        });
      }
    } else {
      if (key.isControlPressed &&
          key.isShiftPressed &&
          key.physicalKey == (PhysicalKeyboardKey.keyE)) {
        setState(() {
          _showSettings = true;
          _focus();
        });
      }
    }
  }

  @override
  void onRun() {
    setState(() {
      _runScreen = !_runScreen;
      _focus();
    });
  }

  StateTree _compileCurrent() {
    StateTreeCompiler obj = StateTreeCompiler();
    return StateTree(code: obj.compile(widget.dispatcher.text));
  }

  void _focus() {
    if (!_keyFocus.hasFocus && _keyFocus.canRequestFocus) {
      _keyFocus.requestFocus();
    }
  }
}
