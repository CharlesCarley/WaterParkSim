import 'package:flutter/material.dart';

import '../metrics.dart';
import '../palette.dart';

class SettingsLabelWidget extends StatelessWidget {
  final String label;
  final double fontSize;
  final Color color;

  const SettingsLabelWidget({
    Key? key,
    required this.label,
    double textSize = 18,
    Color labelColor = Palette.settingsForeground,
  })  : fontSize = textSize,
        color = labelColor,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 1, 1, 1),
      child: Text(
        label,
        style: Styles.labelStyle(
          size: fontSize,
          color: color,
        ),
      ),
    );
  }
}
