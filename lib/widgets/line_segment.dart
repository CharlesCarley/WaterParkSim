import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';

import '../state/settings_state.dart';

class LineSegmentWidget extends StatelessWidget {
  final Offset from;
  final Offset to;
  final Color color;

  const LineSegmentWidget({
    Key? key,
    required this.from,
    required this.to,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: Rect.fromLTWH(
        max(from.dx, to.dx),
        max(from.dy, to.dy),
        max(from.dx, to.dx) - min(from.dx, to.dx),
        max(from.dy, to.dy) - min(from.dy, to.dy),
      ),
      child: CustomPaint(
        painter: LineSegmentPainter(
          from,
          to,
          color,
        ),
      ),
    );
  }
}

class LineSegmentPainter extends CustomPainter {
  final Offset from;
  final Offset to;
  final Paint _paint = Paint();

  LineSegmentPainter(this.from, this.to, Color color) {
    _paint.isAntiAlias = true;
    _paint.strokeWidth = SettingsState.lineSegmentLineSize;
    _paint.color = color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    const Offset origin = Offset(0, 0);
    var newTo = Offset(
      to.dx - from.dx,
      to.dy - from.dy,
    );
    canvas.drawCircle(
      origin,
      SettingsState.lineSegmentEndPointSize,
      _paint,
    );
    canvas.drawLine(origin, newTo, _paint);
    canvas.drawCircle(
      newTo,
      SettingsState.lineSegmentEndPointSize,
      _paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
