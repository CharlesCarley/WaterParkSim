import 'package:flutter/material.dart';
import 'dart:async';

import '../state/settings_state.dart';
import '../widgets/icon_widget.dart';
import '../widgets/toolbar_widget.dart';
import '../palette.dart';
import '../state/state_tree.dart';
import '../util/double_utils.dart';
import '../widgets/event_router.dart';
import '../widgets/program_canvas_ctor.dart';

class RunProgramCanvas extends StatefulWidget {
  final WorkspaceEventDispatcher dispatcher;
  final StateTree tree;

  const RunProgramCanvas({
    Key? key,
    required this.dispatcher,
    required this.tree,
  }) : super(key: key);

  @override
  State<RunProgramCanvas> createState() => _RunProgramCanvasState();
}

class _RunProgramCanvasState extends State<RunProgramCanvas>
    with WorkSpaceEventReceiver {
  StateTree _tree = StateTree.zero();
  late Timer _timer;

  @override
  void initState() {
    widget.dispatcher.subscribe(this);
    _tree = widget.tree;

    DoubleUtils.limIv(Settings.stepRateMs, 10, 1000);

    _timer = Timer.periodic(
      Duration(milliseconds: Settings.stepRateMs),
      _onTick,
    );

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    widget.dispatcher.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Palette.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ToolbarWidget(
            title: _getTitleString(),
            tools: [
              IconWidget(
                icon: IconMappings.exit,
                onClick: () {
                  widget.dispatcher.notifyRun();
                },
                tooltip: "Exit the current simulation (Esc)",
              )
            ],
          ),
          Expanded(
            child: Stack(
              clipBehavior: Clip.hardEdge,
              fit: StackFit.expand,
              children: ProgramCanvasConstructor(
                tree: _tree,
              ).widgets,
            ),
          ),
        ],
      ),
    );
  }

  void _onTick(Timer dur) {
    Future.microtask(
      () => _tree.step(
        Settings.stepRateMs.toDouble(),
      ),
    ).whenComplete(
      (() {
        setState(() {});
      }),
    );
  }

  String _getTitleString() {
    return "Running @ ${Settings.stepRateMs} ms : 1 min";
  }
}
