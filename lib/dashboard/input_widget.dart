import 'package:flutter/material.dart';
import '../metrics.dart';
import '../state/settings_state.dart';
import '../state/input_state.dart';
import '../palette.dart';
import '../widgets/positioned_widgets.dart';

class InputWidget extends StatelessWidget {
  final InputObject state;
  final Rect rect;

  const InputWidget({
    Key? key,
    required this.state,
    required this.rect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PositionedColoredBox(
          rect: rect,
          color: Palette.controlBackground,
        ),
        PositionedColoredBox(
          rect: Rect.fromLTRB(
            rect.left + SettingsState.border,
            rect.top + SettingsState.border,
            rect.right - SettingsState.border,
            rect.bottom - SettingsState.border,
          ),
          color: state.toggle ? Palette.water : Palette.action,
        ),
        Positioned.fromRect(
          rect: rect,
          child: Center(
            child: Text(
              state.flowRate.toStringAsPrecision(
                SettingsState.displayPrecision,
              ),
              style: Common.labelTextStyle,
            ),
          ),
        )
      ],
    );
  }
}
