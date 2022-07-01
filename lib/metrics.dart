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

import 'palette.dart';

class Metrics {
  /// padding variable that is used to measure and build the interface
  static const padding = 32.0;

  /// one half of the default padding
  static const paddingHalf = padding / 2;

  /// one forth of the default padding
  static const paddingForth = padding / 4;

  /// one eighth of the default padding
  static const paddingEighth = padding / 8;

  /// one sixteenth of the default padding
  static const paddingSixteenth = padding / 16;

  /// twice the default padding
  static const paddingDouble = padding * 2;

  /// three times the default padding
  static const paddingTriple = padding * 3;

  /// measurement that is slightly larger that the default text size of 14
  static const textSpacer = 20.0;

  /// The standard icon size
  static const iconSize = 24.0;

  // /// the width of the outer cpu rectangle
  // static const tankWidth = 75.0;

  // /// the width of the outer cpu rectangle
  // static const tankHeight = 150.0;

  /// defines the size of a border around simulation object.
  /// This region is used to place sockets
  static const border = 4.0;

  /// The Height of the title area
  static const titleHeight = 32.0;

  static const lineWidth = 1.5;

  static double defaultTextSize(BuildContext context) {
    final textStyle = DefaultTextStyle.of(context).style;
    final double d = textStyle.fontSize ?? 14;
    return d + 2;
  }

  static Size measureSizedText(String text, double size) {
    var painter = TextPainter(
      text: TextSpan(text: text, style: TextStyle(fontSize: size)),
      textDirection: TextDirection.ltr,
    );
    painter.layout();
    return Size(painter.width, painter.height);
  }

  static Size measureText(String text) {
    return measureSizedText(text, 14);
  }

  static Size _maxIndex = Size.zero;
  static Size get maxIndex => _getMaxIndex();

  static Size _getMaxIndex() {
    // returns the length of the largest index string.
    if (_maxIndex.isEmpty) {
      _maxIndex = measureText("99999");
    }
    return _maxIndex;
  }

  static Size _maxInstruction = Size.zero;
  static Size get maxInstruction => _getMaxInstruction();
  static Size _getMaxInstruction() {
    // returns the length of the largest instruction string.
    if (_maxInstruction.isEmpty) {
      _maxInstruction = measureText("@@@@@@@@@@@@");
    }
    return _maxInstruction;
  }

  static Rect contentRect(BuildContext context, Offset offset, Size size) {
    final textSize = Metrics.defaultTextSize(context);

    return Rect.fromLTWH(
      offset.dx + Metrics.paddingEighth,
      offset.dy + Metrics.paddingForth + textSize,
      size.width - Metrics.paddingForth,
      size.height - Metrics.padding + Metrics.paddingEighth,
    );
  }

  static clamp(double value, double minValue, double maxValue) {
    return value < minValue ? minValue : (value > maxValue ? maxValue : value);
  }
}

class Common {
  /// defines the default text decoration, with no border and a 4 pt padding
  static const InputDecoration defaultTextDecoration = InputDecoration(
    contentPadding: EdgeInsets.all(4.0),
    border: InputBorder.none,
  );

  static final BoxDecoration defaultDecoration = BoxDecoration(
    border: Border.all(color: Palette.action),
  );

  static const TextStyle editTextStyle = TextStyle(
    fontSize: 12,
    fontFamily: "Mono",
    color: Palette.editTextForeground,
  );

  static const TextStyle labelTextStyle = TextStyle(
    fontSize: 14,
    color: Palette.highlight,
  );

  static TextStyle sizedTextStyle(double size, {Color color= Palette.highlight}) {
    return TextStyle(
      fontSize: size,
      color: color,
    );
  }
}
