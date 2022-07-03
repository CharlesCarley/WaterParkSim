/*
-------------------------------------------------------------------------------
    Copyright (c) Charles Carley.

  This software is provided 'as-is', without any express or implied
  warranty. In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.
-------------------------------------------------------------------------------
*/

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
}

class IconWidget extends StatelessWidget {
  final double x, y;
  final String icon;
  final Color color;
  final String tooltip;
  final double size;
  final VoidCallback onClick;

  const IconWidget({
    Key? key,
    required this.icon,
    required this.x,
    required this.y,
    required this.color,
    required this.onClick,
    required this.tooltip,
  })  : size = 16,
        super(key: key);

  const IconWidget.tool(
    this.icon,
    this.x,
    this.y,
    this.onClick,
    this.tooltip, {
    Key? key,
    double? textSize,
    Color? color,
  })  : size = (textSize ?? Metrics.iconSize),
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
