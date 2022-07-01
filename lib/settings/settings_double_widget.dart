import 'package:flutter/material.dart';
import 'package:waterpark_frontend/settings/settings_label_widget.dart';

import '../metrics.dart';
import '../palette.dart';

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
      padding: const EdgeInsets.fromLTRB(4, 1,1,4),
      child: ColoredBox(
        color: Color.fromARGB(180, 25, 25, 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsLabelWidget(
              label: heading,
              textSize: 18,
              labelColor: Palette.settingsForeground,
            ),
            SettingsLabelWidget(
              label: description,
              textSize: 12,
              labelColor: Palette.settingsForeground1,
            ),
            SettingsLabelWidget(
              label: value.toStringAsFixed(2),
              textSize: 14,
              labelColor: Palette.settingsAccent,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 1,1,1),
              child: Slider(
                value: value,
                onChanged: onChanged,
                min: min,
                max: max,
                inactiveColor: Color.fromARGB(255, 54, 54, 58),
                activeColor: Color.fromARGB(255, 105, 131, 169),
                thumbColor: Color.fromARGB(255, 162, 153, 227),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
