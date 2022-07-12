import 'package:flutter/material.dart';

import '../util/double_utils.dart';
import '../metrics.dart';
import '../state/pump_state.dart';
import '../state/settings_state.dart';
import '../palette.dart';

class PumpCanvasWidget extends StatelessWidget {
  final Rect rect;
  final bool on;

  const PumpCanvasWidget({
    Key? key,
    required this.rect,
    required this.on,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: rect,
      child: CustomPaint(
        painter: PumpCanvasPainter(
          rect,
          on,
        ),
      ),
    );
  }
}

class PumpCanvasPainter extends CustomPainter {
  final Rect rect;
  final bool on;
  final Paint _paint = Paint();
  final Path _path = Path();

  PumpCanvasPainter(this.rect, this.on) {
    _paint.isAntiAlias = true;
    _paint.strokeWidth = Settings.lineSegmentLineSize;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double hw = rect.width * 0.5;
    double hh = rect.width * 0.5;

    _paint.color = Palette.tankBorder;
    Offset origin = Offset(rect.width * 0.5, rect.height * 0.5);
    canvas.drawCircle(
      origin,
      DoubleUtils.max(rect.width, rect.height) * 0.5,
      _paint,
    );

    _path.moveTo(hw, hh);
    _path.lineTo(2 * hw, 2 * hh);
    _path.lineTo(0, 2 * hh);
    _path.close();
    canvas.drawPath(_path, _paint);

    _paint.color = on ? Palette.actionSecondary : Palette.action;
    canvas.drawCircle(
      origin,
      DoubleUtils.max(rect.width, rect.height) * 0.4,
      _paint,
    );

    _paint.color = on ? Palette.actionSecondaryLight : Palette.actionLight;
    canvas.drawCircle(
      origin,
      DoubleUtils.max(rect.width, rect.height) * 0.25,
      _paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class PumpWidget extends StatefulWidget {
  final PumpObject state;
  final Rect rect;

  const PumpWidget({
    Key? key,
    required this.state,
    required this.rect,
  }) : super(key: key);

  @override
  State<PumpWidget> createState() => _PumpWidgetState();
}

class _PumpWidgetState extends State<PumpWidget> {
  late PumpObject _inputState;

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
          PumpCanvasWidget(
            rect: Rect.fromLTRB(
              widget.rect.left + Settings.border,
              widget.rect.top + Settings.border,
              widget.rect.right - Settings.border,
              widget.rect.bottom - Settings.border,
            ),
            on: _inputState.toggle,
          ),
          Positioned.fromRect(
            rect: widget.rect,
            child: Center(
              child: Text(
                widget.state.pumpRate.toStringAsPrecision(
                  Settings.displayPrecision,
                ),
                style: Common.labelTextStyleColor(
                  color: _inputState.toggle
                      ? Palette.actionSecondaryText
                      : Palette.actionText,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
