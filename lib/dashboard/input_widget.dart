import 'package:flutter/material.dart';
import '../metrics.dart';
import '../state/settings_state.dart';
import '../state/input_state.dart';
import '../palette.dart';
import '../widgets/positioned_widgets.dart';

class InputWidget extends StatefulWidget {
  final InputObject state;
  final Rect rect;

  const InputWidget({
    Key? key,
    required this.state,
    required this.rect,
  }) : super(key: key);

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {

  late InputObject _inputState;

  @override
  void initState() {
    _inputState = widget.state;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerUp: (event) {
        setState(() {
          _inputState.toggle = !_inputState.toggle;
        });
      },
      child: Stack(
        children: [
          PositionedColoredBox(
            rect: widget.rect,
            color: Palette.controlBackground,
          ),
          PositionedColoredBox(
            rect: Rect.fromLTRB(
              widget.rect.left + SettingsState.border,
              widget.rect.top + SettingsState.border,
              widget.rect.right - SettingsState.border,
              widget.rect.bottom - SettingsState.border,
            ),
            color: _inputState.toggle ? Palette.water : Palette.action,
          ),
          Positioned.fromRect(
            rect: widget.rect,
            child: Center(
              child: Text(
                widget.state.flowRate.toStringAsPrecision(
                  SettingsState.displayPrecision,
                ),
                style: Common.labelTextStyle,
              ),
            ),
          )
        ],
      ),
    );
  }
}
