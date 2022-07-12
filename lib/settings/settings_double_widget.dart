import 'package:flutter/material.dart';

import '../settings/settings_label_widget.dart';
import '../util/double_utils.dart';
import '../palette.dart';

class SettingsDoubleWidget extends StatelessWidget {
  final double value;
  final String heading;
  final String description;
  final double min;
  final double max;
  final double _decimals;
  final ValueChanged<double> onChanged;

  const SettingsDoubleWidget({
    Key? key,
    required this.value,
    required this.heading,
    required this.description,
    required this.onChanged,
    required this.min,
    required this.max,
    double decimals = 0,
  })  : _decimals = decimals,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var units = DoubleUtils.lim(_decimals, 0, 6).toInt();

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 1, 1, 4),
      child: ColoredBox(
        color: const Color.fromARGB(72, 68, 68, 68),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 4),
              child: SettingsLabelWidget(
                label: "$heading:  ${value.toStringAsFixed(units)}",
                textSize: 18,
                labelColor: Palette.settingsForeground,
              ),
            ),
            SettingsLabelWidget(
              label: description,
              textSize: 12,
              labelColor: Palette.settingsForeground1,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 1, 1, 1),
              child: Slider(
                value: value,
                onChanged: (val) => _onChange(val),
                min: min,
                max: max,
                inactiveColor: const Color.fromARGB(255, 54, 54, 58),
                activeColor: const Color.fromARGB(255, 105, 131, 169),
                thumbColor: const Color.fromARGB(255, 162, 153, 227),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onChange(double val) {
    if (_decimals < 1) {
      onChanged.call(val.roundToDouble());
    } else {
      onChanged.call(val);
    }
  }
}
