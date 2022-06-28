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
import '../state/tank.dart';
import '../widgets/label.dart';
import '../metrics.dart';
import '../palette.dart';
import '../widgets/pcolorbox.dart';

class TankWidget extends StatelessWidget {
  final Tank state;

  const TankWidget({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Rect base = Rect.fromLTWH(
      state.x,
      state.y,
      Metrics.tankWidth,
      Metrics.tankHeight,
    );

    final Rect inner = Rect.fromLTRB(
      base.left + Metrics.border,
      base.top + Metrics.border,
      base.right - Metrics.border,
      base.bottom - Metrics.border,
    );

    final double innerRectHeight = inner.bottom - inner.top;

    final Rect levelTop = Rect.fromLTRB(
      inner.left,
      inner.bottom -
          ((Metrics.clamp(state.level, 0, state.height) / state.height) *
              innerRectHeight),
      inner.right,
      inner.bottom,
    );

    var text = Metrics.measureText(state.height.toString());

    final Rect textRect = Rect.fromLTRB(
      levelTop.left + (levelTop.right - levelTop.left) / 2 - text.width / 2,
      levelTop.top - text.height / 2,
      levelTop.right,
      levelTop.bottom,
    );

    return Stack(children: [
      PositionedColoredBox(
        rect: base,
        color: Palette.tankBorder,
      ),
      PositionedColoredBox(
        rect: inner,
        color: Palette.tankBackground,
      ),
      PositionedColoredBox(
        rect: levelTop,
        color: state.level <= state.height ? Palette.water : Palette.action,
      ),
      Positioned.fromRect(
        rect: inner,
        child: LabelWidget(
          x: textRect.left,
          y: textRect.top,
          color: Palette.wireChange,
          text: state.level.toString(),
        ),
      ),
    ]);
  }
}

class SocketWidget extends StatelessWidget {
  final Sock state;
  final Rect rect;

  const SocketWidget({
    Key? key,
    required this.state,
    required this.rect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PositionedColoredBox(
      rect: rect,
      color: Palette.socketColor,
    );
  }
}
