/*
-------------------------------------------------------------------------------
    Copyright (c) Charles Carley.

  This software is provided 'as-is', without any express or implied
  warranty. In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.
-------------------------------------------------------------------------------
*/

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
    final Size textSize = Metrics.measureSizedText(text, size);

    return Positioned.fromRect(
      rect: Rect.fromLTRB(x, y, x + textSize.width, y + textSize.height),
      child: Text(
        text,
        style: Common.labelTextStyle,
      ),
    );
  }
}
