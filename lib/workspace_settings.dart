import 'package:flutter/material.dart';
import 'metrics.dart';
import 'palette.dart';
import 'state/settings_state.dart';
import 'widgets/event_router.dart';
import 'widgets/icon_widget.dart';
import 'settings/settings_double_widget.dart';
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
    DoubleUtils.limDv(Settings.inputObjectWidth, 40, 100);
    DoubleUtils.limDv(Settings.inputObjectHeight, 30, 100);
    DoubleUtils.limDv(Settings.lineSegmentLineSize, 0.01, 5);
    DoubleUtils.limDv(Settings.menuHeight, 8, 36);
    DoubleUtils.limDv(Settings.border, 1, 10);
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
                    style: Common.sizedTextStyle(1.5 * Settings.menuHeight,
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
                      value: Settings.menuHeight,
                      heading: "menuHeight",
                      description: "Controls the height of menubars.",
                      min: 8,
                      max: 36,
                      onChanged: (val) {
                        setState(() {
                          Settings.menuHeight = val;
                        });
                      },
                    ),
                    SettingsDoubleWidget(
                      value: Settings.inputObjectWidth,
                      heading: "inputObjectWidth",
                      description: "Controls the width of the input object.",
                      min: 40,
                      max: 100,
                      onChanged: (val) {
                        setState(() {
                          Settings.inputObjectWidth = val;
                        });
                      },
                    ),
                    SettingsDoubleWidget(
                      value: Settings.inputObjectHeight,
                      heading: "inputObjectHeight",
                      description: "Controls the height of the input object.",
                      min: 30,
                      max: 100,
                      onChanged: (val) {
                        setState(() {
                          Settings.inputObjectHeight = val;
                        });
                      },
                    ),
                    SettingsDoubleWidget(
                      value: Settings.lineSegmentLineSize,
                      heading: "lineSize",
                      description: "Controls stroke width of a line segment.",
                      min: 0.01,
                      max: 5,
                      decimals: 2,
                      onChanged: (val) {
                        setState(() {
                          Settings.lineSegmentLineSize = val;
                        });
                      },
                    ),
                    SettingsDoubleWidget(
                      value: Settings.lineSegmentEndPointSize,
                      heading: "endPointSize",
                      description:
                          "Controls the radius of line segment end points.",
                      min: 0.01,
                      max: 5,
                      decimals: 2,
                      onChanged: (val) {
                        setState(() {
                          Settings.lineSegmentEndPointSize = val;
                        });
                      },
                    ),
                    SettingsDoubleWidget(
                      value: Settings.tankWidth,
                      heading: "tankWidth",
                      description: "Controls tank object's width.",
                      min: 40,
                      max: 300,
                      onChanged: (val) {
                        setState(() {
                          Settings.tankWidth = val;
                        });
                      },
                    ),
                    SettingsDoubleWidget(
                      value: Settings.tankHeight,
                      heading: "tankHeight",
                      description: "Controls tank object's height.",
                      min: 40,
                      max: 300,
                      onChanged: (val) {
                        setState(() {
                          Settings.tankHeight = val;
                        });
                      },
                    ),
                    SettingsDoubleWidget(
                      value: Settings.border,
                      heading: "border",
                      description: "Controls a general border metric.",
                      min: 1,
                      max: 10,
                      onChanged: (val) {
                        setState(() {
                          Settings.border = val;
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
