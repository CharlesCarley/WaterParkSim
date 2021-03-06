import 'package:flutter/material.dart';

import 'palette.dart';
import 'simulation/state_execute.dart';
import 'widgets/event_router.dart';
import 'program_canvas_view.dart';

class ProgramCanvas extends StatefulWidget {
  final WorkspaceEventDispatcher dispatcher;
  const ProgramCanvas({
    Key? key,
    required this.dispatcher,
  })  : super(key: key);

  @override
  State<ProgramCanvas> createState() => _ProgramCanvasState();
}

class _ProgramCanvasState extends State<ProgramCanvas>
    with WorkSpaceEventReceiver {
  StateTreeExecutor _tree = StateTreeExecutor.zero();

  @override
  void initState() {
    widget.dispatcher.subscribe(this);
    super.initState();
  }

  @override
  void dispose() {
    widget.dispatcher.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Palette.background,
      child: Stack(
        fit: StackFit.expand,
        children: ProgramCanvasConstructor(
          tree: _tree,
        ).widgets,
      ),
    );
  }

  @override
  void onStateTreeCompiled(StateTreeExecutor stateTree) {
    setState(() {
      _tree = stateTree;
    });
  }

  @override
  void onDisplaySettingsClosed() {
    setState(() {});
  }
}
