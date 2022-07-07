import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:waterpark/metrics.dart';
import 'package:waterpark/widgets/icon_widget.dart';
import '../palette.dart';
import '../state/state_manager.dart';
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
    _timer = Timer.periodic(
      const Duration(milliseconds: 20),
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
          ColoredBox(
            color: Palette.backgroundLight,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    "Running....",
                    style: Common.sizedTextStyle(14),
                  ),
                ),
                const Spacer(),
                IconWidget(
                  icon: IconMappings.exit,
                  onClick: () {
                    widget.dispatcher.notifyRun();
                  },
                ),
              ],
            ),
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
    Future.microtask(() => _tree.step(20)).whenComplete((() {
      setState(() {});
    }));
  }
}