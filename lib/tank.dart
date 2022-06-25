

import 'package:flutter/material.dart';

import 'label.dart';
import 'metrics.dart';
import 'palette.dart';
import 'rect-widget.dart';
class TankWidget extends StatelessWidget {


  
  final double x, y;
  final double border = 4;
  final double TankHeight;
  final double WaterHeight;

  const TankWidget(this.x, this.y, this.TankHeight, this.WaterHeight,
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

    final Rect vrect = Rect.fromLTRB(
      inner.left,
      inner.bottom -
          ((Metrics.clamp(WaterHeight, 0, TankHeight) / TankHeight) *
              innerRectHeight),
      inner.right,
      inner.bottom,
    );

    return Stack(children: [
      RectWidget(
        base,
        Palette.tankBorder,
      ),
      RectWidget(
        inner,
        Palette.tankBackground,
      ),
      RectWidget(
        vrect,
        Palette.water,
      ),
      LabelWidget(
        inner.left,
        inner.top,
        Palette.wireChange,
        WaterHeight.toString(),
      ),
    ]);
  }
}
