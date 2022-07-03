import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'palette.dart';
import 'state/state_manager.dart';
import 'widgets/event_router.dart';
import 'widgets/program_canvas_ctor.dart';

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
  StateTree _tree = StateTree.zero();

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
        clipBehavior: Clip.hardEdge,
        fit: StackFit.expand,
        children: ProgramCanvasConstructor(
          tree: _tree,
        ).widgets,
      ),
    );
  }

  @override
  void onStateTreeCompiled(StateTree stateTree) {
    setState(() {
      _tree = stateTree;
    });
  }

  @override
  void onDisplaySettingsClosed() {
    setState(() {});
  }
}
