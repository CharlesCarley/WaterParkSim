import 'package:flutter/material.dart';

import '../metrics.dart';
import '../palette.dart';

class ActionIcon extends StatelessWidget {
  final double x, y;
  final String icon;
  final Color color;
  final String tooltip;
  final double size;
  final VoidCallback onClick;

  const ActionIcon({
    Key? key,
    required this.icon,
    required this.x,
    required this.y,
    required this.color,
    required this.onClick,
    required this.tooltip,
  })  : size = 16,
        super(key: key);

  const ActionIcon.tool(
      {Key? key,
      double? textSize,
      Color? color,
      required this.icon,
      required this.x,
      required this.y,
      required this.onClick,
      required this.tooltip})
      : size = (textSize ?? Metrics.iconSize),
        color = (color ?? Palette.wire),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      clipBehavior: Clip.none,
      onPressed: onClick,
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
      child: Tooltip(
        message: tooltip,
        textStyle: const TextStyle(
          color: Palette.toolTipForeground,
          fontSize: 10,
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
