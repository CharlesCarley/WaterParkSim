import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../state/settings_state.dart';

class LineSegmentWidget extends StatelessWidget {
  final Offset from;
  final Offset to;
  final Color color;
  final double endPointSize;

  const LineSegmentWidget({
    Key? key,
    required this.from,
    required this.to,
    required this.color,
    required this.endPointSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: Rect.fromLTWH(
        from.dx,
        from.dy,
        max(from.dx, to.dx) - min(from.dx, to.dx),
        max(from.dy, to.dy) - min(from.dy, to.dy),
      ),
      child: CustomPaint(
        painter: LineSegmentPainter(
          from,
          to,
          color,
          endPointSize,
        ),
      ),
    );
  }
}

class LineSegmentPainter extends CustomPainter {
  final Offset from;
  final Offset to;
  final double endPointSize;
  final Color color;
  late Color socketColor;
  final Paint _paint = Paint();

  LineSegmentPainter(
    this.from,
    this.to,
    this.color,
    this.endPointSize,
  ) {
    _paint.isAntiAlias = true;
    _paint.strokeWidth = Settings.lineSegmentLineSize;

    // color wraps on overflow..
    socketColor = Color.fromARGB(
      color.alpha,
      min(color.red + 20, 255),
      min(color.green + 20, 255),
      min(color.blue + 20, 255),
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    const Offset origin = Offset(0, 0);
    var newTo = Offset(
      to.dx - from.dx,
      to.dy - from.dy,
    );
    _paint.color = color;
    canvas.drawLine(origin, newTo, _paint);

    _paint.color = socketColor;
    canvas.drawCircle(
      origin,
      endPointSize,
      _paint,
    );
    canvas.drawCircle(
      newTo,
      endPointSize,
      _paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
