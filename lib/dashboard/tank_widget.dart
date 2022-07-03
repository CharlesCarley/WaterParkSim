import 'package:flutter/material.dart';
import 'package:waterpark/state/settings_state.dart';
import 'package:waterpark/util/double_utils.dart';
import '../state/tank_state.dart';
import '../widgets/label_widget.dart';
import '../metrics.dart';
import '../palette.dart';
import '../widgets/positioned_widgets.dart';

class TankWidget extends StatelessWidget {
  final TankObject state;

  const TankWidget({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var base = Rect.fromLTWH(
      state.x,
      state.y,
      SettingsState.tankWidth,
      SettingsState.tankHeight,
    );
    var inner = Rect.fromLTRB(
      base.left + SettingsState.border,
      base.top + SettingsState.border,
      base.right - SettingsState.border,
      base.bottom - SettingsState.border,
    );

    var innerRectHeight = inner.bottom - inner.top;
    var levelTop = Rect.fromLTRB(
      inner.left,
      inner.bottom -
          ((DoubleUtils.lim(state.level, 0, state.height) / state.height) *
              innerRectHeight),
      inner.right,
      inner.bottom,
    );

    var text = Metrics.measureText(state.height.toString());
    var textRect = Rect.fromLTRB(
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
