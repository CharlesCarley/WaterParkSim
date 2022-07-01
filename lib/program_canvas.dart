import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:waterpark_frontend/state/state_manager.dart';
import 'package:waterpark_frontend/widgets/event_router.dart';

import 'dashboard/program_canvas_ctor.dart';

class ProgramCanvas extends StatefulWidget {
  final WorkspaceEventDispatcher dispatcher;

  const ProgramCanvas({
    Key? key,
    required this.dispatcher,
  }) : super(key: key);

  @override
  State<ProgramCanvas> createState() => _ProgramCanvasState();
}

class _ProgramCanvasState extends State<ProgramCanvas>
    with WorkSpaceEventReceiver {
  StateTree tree = StateTree.zero();

  @override
  void dispose() {
    widget.dispatcher.unsubscribe(this);
    super.dispose();
  }

  @override
  void initState() {
    widget.dispatcher.subscribe(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: tree.clearColor,
      child: Stack(
        children: ProgramCanvasConstructor(
          tree: tree,
        ).widgets,
      ),
    );
  }


  @override
  void onStateTreeCompiled(StateTree stateTree) {
    setState(() {
      tree = stateTree;
    });
  }
}
