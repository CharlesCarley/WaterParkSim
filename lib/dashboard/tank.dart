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
import '../widgets/label.dart';
import '../metrics.dart';
import '../palette.dart';
import '../widgets/pcolorbox.dart';

class TankWidget extends StatelessWidget {
  final double x, y;
  final double border = 4;
  final double tankHeight;
  final double waterHeight;

  const TankWidget(this.x, this.y, this.tankHeight, this.waterHeight,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Rect base = Rect.fromLTRB(
      x,
      y,
      x + Metrics.tankWidth,
      y + Metrics.tankHeight,
    );

    final Rect inner = Rect.fromLTRB(
      base.left + border,
      base.top + border,
      base.right - border,
      base.bottom - border,
    );

    final double innerRectHeight = inner.bottom - inner.top;

    final Rect levelTop = Rect.fromLTRB(
      inner.left,
      inner.bottom -
          ((Metrics.clamp(waterHeight, 0, tankHeight) / tankHeight) *
              innerRectHeight),
      inner.right,
      inner.bottom,
    );

    var text = Metrics.measureText(waterHeight.toString());

    final Rect textRect = Rect.fromLTRB(
      levelTop.left + (levelTop.right - levelTop.left)/2 - text.width / 2,
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
        color: Palette.water,
      ),
      Positioned.fromRect(
        rect: levelTop,
        child: LabelWidget(
          x: textRect.left,
          y: textRect.top,
          color: Palette.wireChange,
          text: waterHeight.toString(),
        ),
      ),
    ]);
  }
}
