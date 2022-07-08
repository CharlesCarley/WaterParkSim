import 'package:flutter/material.dart';
import 'package:waterpark/metrics.dart';
import 'package:waterpark/palette.dart';
import 'package:waterpark/state/settings_state.dart';
import 'package:waterpark/widgets/event_router.dart';
import 'package:waterpark/widgets/icon_widget.dart';
import '../settings/settings_double_widget.dart';
import 'util/double_utils.dart';

class WorkspaceSettings extends StatefulWidget {
  final Rect rect;
  final WorkspaceEventDispatcher dispatcher;

  const WorkspaceSettings({
    Key? key,
    required this.rect,
    required this.dispatcher,
  }) : super(key: key);

  @override
  State<WorkspaceSettings> createState() => _WorkspaceSettingsState();
}

class _WorkspaceSettingsState extends State<WorkspaceSettings> {
  @override
  void initState() {
    DoubleUtils.lim(SettingsState.inputObjectWidth, 40, 100);
    DoubleUtils.lim(SettingsState.inputObjectHeight, 40, 100);
    DoubleUtils.lim(SettingsState.lineSegmentLineSize, 0.01, 5);
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
                    "Workspace Parameters",
                    style: Common.sizedTextStyle(24,
                        color: Palette.titleForeground),
                  ),
                ),
                const Spacer(),
                IconWidget(
                  icon: IconMappings.exit,
                  color: Palette.highlight,
                  onClick: () {
                    widget.dispatcher.notifyDisplaySettingsClosed();
                  },
                  tooltip: "Closes the settings panel (Esc)",
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 16),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    SettingsDoubleWidget(
                      value: SettingsState.menuHeight,
                      heading: "menuHeight",
                      description: "Controls the height of menubars.",
                      min: 10,
                      max: 72,
                      onChanged: (val) {
                        setState(() {
                          SettingsState.menuHeight = val;
                        });
                      },
                    ),
                    SettingsDoubleWidget(
                      value: SettingsState.inputObjectWidth,
                      heading: "inputObjectWidth",
                      description: "Controls the width of the input object.",
                      min: 40,
                      max: 100,
                      onChanged: (val) {
                        setState(() {
                          SettingsState.inputObjectWidth = val;
                        });
                      },
                    ),
                    SettingsDoubleWidget(
                      value: SettingsState.inputObjectHeight,
                      heading: "inputObjectHeight",
                      description: "Controls the height of the input object.",
                      min: 40,
                      max: 100,
                      onChanged: (val) {
                        setState(() {
                          SettingsState.inputObjectHeight = val;
                        });
                      },
                    ),
                    SettingsDoubleWidget(
                      value: SettingsState.lineSegmentLineSize,
                      heading: "lineSize",
                      description: "Controls stroke width of a line segment.",
                      min: 0.01,
                      max: 5,
                      decimals: 2,
                      onChanged: (val) {
                        setState(() {
                          SettingsState.lineSegmentLineSize = val;
                        });
                      },
                    ),
                    SettingsDoubleWidget(
                      value: SettingsState.lineSegmentEndPointSize,
                      heading: "endPointSize",
                      description:
                          "Controls the radius of line segment end points.",
                      min: 0.01,
                      max: 5,
                      decimals: 2,
                      onChanged: (val) {
                        setState(() {
                          SettingsState.lineSegmentEndPointSize = val;
                        });
                      },
                    ),
                    SettingsDoubleWidget(
                      value: SettingsState.tankWidth,
                      heading: "tankWidth",
                      description: "Controls tank object's width.",
                      min: 40,
                      max: 300,
                      onChanged: (val) {
                        setState(() {
                          SettingsState.tankWidth = val;
                        });
                      },
                    ),
                    SettingsDoubleWidget(
                      value: SettingsState.tankHeight,
                      heading: "tankHeight",
                      description: "Controls tank object's height.",
                      min: 40,
                      max: 300,
                      onChanged: (val) {
                        setState(() {
                          SettingsState.tankHeight = val;
                        });
                      },
                    ),
                    SettingsDoubleWidget(
                      value: SettingsState.border,
                      heading: "border",
                      description: "Controls a general border metric.",
                      min: 1,
                      max: 10,
                      onChanged: (val) {
                        setState(() {
                          SettingsState.border = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ]),
    );
  }
}
