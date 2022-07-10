import 'package:flutter/material.dart';

import '../metrics.dart';
import '../palette.dart';

class IconMappings {
  static const String play = '#';
  static const String github = '%';
  static const String add = 'a';
  static const String more = 'K';
  static const String file = 'L';
  static const String power = 'M';
  static const String screen = 'N';
  static const String next = 'O';
  static const String edit = 'b';
  static const String brush = 'e';
  static const String exit = 'g';
  static const String gears = 's';
  static const String help = 's';
}

class IconWidget extends StatelessWidget {
  final String icon;
  final Color color;
  final String tooltip;
  final double size;
  final VoidCallback onClick;

  const IconWidget({
    Key? key,
    required this.icon,
    required this.onClick,
    String? tooltip,
    Color? color,
    double? textSize,
  })  : size = textSize ?? 16,
        color = color ?? Palette.titleIcon,
        tooltip = tooltip ?? "",
        super(key: key);

  const IconWidget.tool({
    required this.icon,
    required this.onClick,
    String? tooltip,
    Key? key,
    double? textSize,
    Color? color,
  })  : size = (textSize ?? Metrics.iconSize),
        color = (color ?? Palette.titleIcon),
        tooltip = tooltip ?? "",
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      clipBehavior: Clip.hardEdge,
      onPressed: onClick,
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
      child: Tooltip(
        message: tooltip,
        textStyle: const TextStyle(
          color: Palette.toolTipForeground,
          fontSize: Metrics.tooltipSize,
        ),
        decoration: const BoxDecoration(
          color: Palette.toolTipBackground,
        ),
        child: Text(
          icon,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color,
            fontFamily: 'Icons',
            fontSize: size,
          ),
        ),
      ),
    );
  }
}
