import 'package:flutter/material.dart';

import '../metrics.dart';
import '../palette.dart';

class HelpCommandText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;

  const HelpCommandText({
    Key? key,
    required this.text,
    required this.fontSize,
    Color labelColor = Palette.settingsForeground,
  })  : color = labelColor,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
      child: Text(
        text,
        style: Styles.labelStyle(
          size: fontSize,
          color: color,
        ),
      ),
    );
  }
}

class HelpCommand extends StatelessWidget {
  final String label;
  final String subHeading;
  final String description;
  final double fontSize;
  final Color color;

  const HelpCommand({
    Key? key,
    required this.label,
    required this.subHeading,
    required this.description,
    double textSize = 18,
    Color labelColor = Palette.settingsForeground,
  })  : fontSize = textSize,
        color = labelColor,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 1, 1, 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HelpCommandText(
            fontSize: fontSize,
            text: label,
          ),
          HelpCommandText(
            fontSize: fontSize - 3,
            text: subHeading,
          ),
          HelpCommandText(
            fontSize: fontSize - 5,
            text: description,
          ),
        ],
      ),
    );
  }
}
