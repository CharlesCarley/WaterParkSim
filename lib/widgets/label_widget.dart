import 'package:flutter/material.dart';

import '../metrics.dart';

class LabelWidget extends StatelessWidget {
  final Color color;
  final String text;
  final double x;
  final double y;
  final double size = 14;

  const LabelWidget({
    super.key,
    required this.x,
    required this.y,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(text, style: Common.labelTextStyle));
  }
}
