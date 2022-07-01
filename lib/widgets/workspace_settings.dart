import 'package:flutter/material.dart';
import 'package:waterpark_frontend/metrics.dart';
import 'package:waterpark_frontend/state/settings_state.dart';
import 'package:waterpark_frontend/widgets/event_router.dart';
import '../palette.dart';
import 'positioned_widgets.dart';

class SettingsDoubleWidget extends StatelessWidget {
  final double value;
  final String heading;
  final String description;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const SettingsDoubleWidget({
    Key? key,
    required this.value,
    required this.heading,
    required this.description,
    required this.onChanged,
    required this.min,
    required this.max,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ColoredBox(
        color: Color.fromARGB(165, 19, 19, 19),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8, 0, 4),
              child: Text(
                heading,
                style: Common.sizedTextStyle(
                  18,
                  color: Palette.settingsForeground,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0,0,4),
              child: Text(
                description,
                style: Common.sizedTextStyle(
                  14,
                  color: Palette.settingsForeground1,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 4),
              child: Text(
                value.toStringAsFixed(2),
                style: Common.sizedTextStyle(
                  20,
                  color: Palette.settingsForeground2,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Slider(
                value: value,
                onChanged: onChanged,
                min: min,
                max: max,
                inactiveColor: Palette.wireLight,
                activeColor: Color.fromARGB(255, 69, 137, 233),
                thumbColor: Color.fromARGB(255, 210, 187, 210),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: widget.rect,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ///////////////////////////////////////
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Settings",
                style: Common.sizedTextStyle(24),
              ),
            ),

            /// ///////////////////////////////////////
            SettingsDoubleWidget(
              value: SettingsState.inputObjectWidth,
              heading: "SettingsState.inputObjectWidth",
              description: "description",
              min: 10,
              max:  75,
              onChanged: (val) {
                setState(() {
                  SettingsState.inputObjectWidth = val;
                });
              },
            ),
            SettingsDoubleWidget(
              value: SettingsState.inputObjectHeight,
              heading: "SettingsState.inputObjectHeight",
              description: "description",
              min: 10,
              max:  75,
              onChanged: (val) {
                setState(() {
                  SettingsState.inputObjectHeight = val;
                });
              },
            ),           SettingsDoubleWidget(
              value: SettingsState.linSegmentLineSize,
              heading: "SettingsState.linSegmentLineSize",
              description: "description",
              min: 0.01,
              max:  5,
              onChanged: (val) {
                setState(() {
                  SettingsState.linSegmentLineSize = val;
                });
              },
            )


            /// ///////////////////////////////////////
          ]),
    );
  }
}
