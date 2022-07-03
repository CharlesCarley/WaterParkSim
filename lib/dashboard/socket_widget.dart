import 'package:flutter/material.dart';
import '../state/socket_state.dart';
import '../palette.dart';
import '../widgets/positioned_widgets.dart';

class SocketWidget extends StatelessWidget {
  final SockObject state;
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
