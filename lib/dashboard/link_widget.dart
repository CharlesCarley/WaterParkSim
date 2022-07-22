import 'dart:math';

import 'package:flutter/material.dart';
import 'package:waterpark/metrics.dart';
import 'package:waterpark/state/settings_state.dart';
import '../state/socket_state.dart';
import '../palette.dart';
import '../widgets/line_segment.dart';

class LinkWidget extends StatefulWidget {
  final SockObject from;
  final SockObject to;

  const LinkWidget({
    Key? key,
    required this.from,
    required this.to,
  }) : super(key: key);

  @override
  State<LinkWidget> createState() => _LinkWidgetState();
}

class _LinkWidgetState extends State<LinkWidget> {
  late String cacheText;

  @override
  void initState() {
    cacheText = "";

    widget.from.onChange = _onCachePushed;
    widget.to.onChange = _onCachePushed;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var base = Rect.fromLTWH(
      min(widget.from.ax, widget.to.ax),
      min(widget.from.ay, widget.to.ay),
      max(widget.from.ax, widget.to.ax) - min(widget.from.ax, widget.to.ax),
      max(widget.from.ay, widget.to.ay) - min(widget.from.ay, widget.to.ay),
    );

    var textRect = Rect.fromLTRB(
      base.left + Settings.border,
      base.bottom + Settings.border,
      base.right,
      base.bottom + Styles.labelTextSize + Settings.border,
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        LineSegmentWidget(
          from: Offset(widget.from.ax, widget.from.ay),
          to: Offset(widget.to.ax, widget.to.ay),
          color: Palette.socketColor,
          endPointSize: Settings.lineSegmentEndPointSize,
        ),
        Positioned.fromRect(
          rect: textRect,
          child: Text(
            cacheText,
            style: Styles.labelStyle(
              size: 12,
              color: Styles.labelTextColorBright,
            ),
          ),
        ),
      ],
    );
  }

  void _onCachePushed() {
    setState(() {
      var b = widget.to.peekCache();
      cacheText = b.toStringAsPrecision(3);
    });
  }
}
