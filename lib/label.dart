
import 'package:flutter/material.dart';

import 'metrics.dart';

class LabelWidget extends StatelessWidget {
  final Color color;
  final String text;
  final double x;
  final double y;
  final double size = 14;

  const LabelWidget(this.x, this.y, this.color, this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final Size textSize = Metrics.measureSizedText(text, size);

    return Positioned.fromRect(
      rect: Rect.fromLTRB(x, y, x + textSize.width, y + textSize.height),
      child: Text(
        text,
        style: Common.labelTextStyle,
      ),
    );
  }
}