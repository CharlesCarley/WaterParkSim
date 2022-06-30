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

import 'dart:ui';

import 'package:flutter/material.dart';
import '../state/socket_object.dart';
import '../palette.dart';
import '../widgets/pcolorbox.dart';

class LinkWidget extends StatelessWidget {
  final SockObject state;
  final SockObject link;
  final Rect rect;

  const LinkWidget({
    Key? key,
    required this.state,
    required this.link,
    required this.rect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Rect container = Rect.fromLTRB(
      state.ax,
      state.ay,
      link.ax,
      link.ay,
    );

    return Positioned.fromRect(
      rect: container,
      child: CustomPaint(painter: LinePainter(state, link)),
    );
  }
}

class LinePainter extends CustomPainter {
  final SockObject state;
  final SockObject link;

  LinePainter(this.state, this.link);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint p = Paint();
    p.isAntiAlias = true;
    p.strokeWidth = 4;
    p.color = Palette.wireChange;
    const Offset origin = Offset(0, 0);

    Offset to = Offset(link.ax - state.ax, link.ay - state.ay);

    canvas.drawCircle(origin, 4, p);
    canvas.drawLine(origin, to, p);
    canvas.drawCircle(to, 4, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
