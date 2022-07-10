
import 'package:flutter/material.dart';

class PositionedColoredBox extends StatelessWidget {
  final Rect rect;
  final Color color;

  const PositionedColoredBox({
    Key? key,
    required this.rect,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: rect,
      child: ColoredBox(
        color: color,
      ),
    );
  }
}

class PositionedColoredBoxEx extends StatelessWidget {
  final Rect rect;
  final Color color;
  final Widget child;

  const PositionedColoredBoxEx ({
    Key? key,
    required this.child,
    required this.rect,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: rect,
      child: ColoredBox(
        color: color,
        child: child,
      ),
    );
  }
}
