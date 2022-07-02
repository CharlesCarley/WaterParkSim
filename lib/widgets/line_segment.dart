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
