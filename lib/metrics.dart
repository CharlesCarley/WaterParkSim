import 'package:flutter/material.dart';
import 'palette.dart';

class Metrics {
  static const toolBarSize = 36.0;

  static const iconSize = 24.0;

  static const double tooltipSize = 12;

  static Size measureSizedText(String text, double size) {
    var painter = TextPainter(
      text: TextSpan(text: text, style: TextStyle(fontSize: size)),
      textDirection: TextDirection.ltr,
    );
    painter.layout();
    return Size(painter.width, painter.height);
  }

  static Size measureText(String text, {double size = 14}) {
    return measureSizedText(text, size);
  }
}

class Common {
  static const double editTextSize = 12;
  static const TextStyle editTextStyle = TextStyle(
    fontSize: editTextSize,
    fontFamily: "Mono",
    color: Palette.highlight,
  );

  static const double labelTextSize = 14;
  static const TextStyle labelTextStyle = TextStyle(
    fontSize: labelTextSize,
    fontFamily: "RobotoMedium",
    color: Palette.highlight,
  );

  static TextStyle sizedTextStyle(double size,
      {Color color = Palette.highlight}) {
    return TextStyle(
      fontSize: size,
      color: color,
      fontFamily: "RobotoMedium",
    );
  }
}
