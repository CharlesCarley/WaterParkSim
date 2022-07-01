import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waterpark_frontend/theme.dart';
import 'package:waterpark_frontend/util/double_utils.dart';
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
      title: 'WaterPark Demo',
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
            foregroundColor: Palette.titleForeground,
            backgroundColor: Palette.titleBackground,
            title: Text(SettingsState.title),
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

    if (showSettings) {

      double w = DoubleUtils.lim(_size.width, 300, double.maxFinite);
      double h = DoubleUtils.lim(_size.height, 300, double.maxFinite);

      body.add(
        WorkspaceSettings(
          dispatcher: dispatcher,
          rect: Rect.fromLTWH(w/2, 0, w/2, h),
        ),
      );
    } else {
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
      keyFocus.requestFocus();
    });
  }

  @override
  void onKey(RawKeyEvent key) {
    if (key.physicalKey == (PhysicalKeyboardKey.escape)) {
      setState(() {
        showSettings = false;
      });
    }
  }
}
