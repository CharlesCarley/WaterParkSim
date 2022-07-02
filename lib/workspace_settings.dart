import 'package:flutter/material.dart';
import 'package:waterpark_frontend/metrics.dart';
import 'package:waterpark_frontend/palette.dart';
import 'package:waterpark_frontend/state/settings_state.dart';
import 'package:waterpark_frontend/widgets/event_router.dart';
import 'package:waterpark_frontend/widgets/icon_widget.dart';
import '../settings/settings_double_widget.dart';

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
    _rangeLimit(SettingsState.inputObjectWidth, 40, 100);
    _rangeLimit(SettingsState.inputObjectHeight, 40, 100);
    _rangeLimit(SettingsState.lineSegmentLineSize, 0.01, 4);
    super.initState();
  }

  void _rangeLimit(double val, double mi, double ma) {
    if (val < mi) {
      val = mi;
    }
    if (val > ma) {
      val = ma;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Palette.backgroundLight,
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
                    style: Common.sizedTextStyle(24),
                  ),
                ),
                const Spacer(),
                 IconWidget(
                  icon: IconMappings.exit,
                  x: 0,
                  y: 0,
                  color: Palette.wire,
                  onClick: (){
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
                      onChanged: (val) {
                        setState(() {
                          SettingsState.lineSegmentEndPointSize = val;
                        });
                      },
                    ),
                    SettingsDoubleWidget(
                      value: SettingsState.tankWidth,
                      heading: "tankWidth",
                      description:
                          "Controls tank object's width.",
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
                      description:
                          "Controls tank object's height.",
                      min: 40,
                      max: 300,
                      onChanged: (val) {
                        setState(() {
                          SettingsState.tankHeight = val;
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
