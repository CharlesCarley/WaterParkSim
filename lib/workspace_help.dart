import 'package:flutter/material.dart';
import 'package:waterpark/metrics.dart';
import 'package:waterpark/palette.dart';
import 'package:waterpark/widgets/event_router.dart';
import 'package:waterpark/widgets/icon_widget.dart';

import 'editor/help_command.dart';

class WorkspaceHelp extends StatefulWidget {
  final Rect rect;
  final WorkspaceEventDispatcher dispatcher;

  const WorkspaceHelp({
    Key? key,
    required this.rect,
    required this.dispatcher,
  }) : super(key: key);

  @override
  State<WorkspaceHelp> createState() => _WorkspaceHelpState();
}

class _WorkspaceHelpState extends State<WorkspaceHelp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Palette.background,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 16, 8, 16),
                  child: Text(
                    "Script Command",
                    style: Styles.labelStyle(
                      size: 24,
                      color: Palette.titleForeground,
                    ),
                  ),
                ),
                const Spacer(),
                IconWidget(
                  icon: IconMappings.exit,
                  color: Palette.highlight,
                  onClick: () {
                    widget.dispatcher.notifyHelpClosed();
                  },
                  tooltip: "Closes the panel (Esc)",
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 16),
                child: ListView(
                  shrinkWrap: true,
                  children: const [
                    HelpCommand(
                      label: "input",
                      subHeading: "input <x> <y> <rate>",
                      description:
                          "Is an element that relays a rate to output socket connections.",
                    ),
                    HelpCommand(
                      label: "state",
                      subHeading: "state <toggle>",
                      description:
                          "Is an element that can switch the state of the previous element on the stack .",
                    ),
                  ],
                ),
              ),
            ),
          ]),
    );
  }
}
