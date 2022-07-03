import 'package:flutter/material.dart';
import '../state/socket_state.dart';
import '../palette.dart';
import '../widgets/line_segment.dart';

class LinkWidget extends StatelessWidget {
  final SockObject state;
  final SockObject link;

  const LinkWidget({
    Key? key,
    required this.state,
    required this.link,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineSegmentWidget(
      from: Offset(state.ax, state.ay),
      to: Offset(link.ax, link.ay),
      color: Palette.wire,
    );
  }
}
