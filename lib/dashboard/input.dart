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
import 'package:waterpark_frontend/metrics.dart';
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
            rect.left + Metrics.border,
            rect.top + Metrics.border,
            rect.right - Metrics.border,
            rect.bottom - Metrics.border,
          ),
          color: state.toggle ? Palette.water : Palette.action,
        ),
        Positioned.fromRect(
          rect: rect,
          child: Center(
            child: Text(
              state.flowRate.toString(),
              style: Common.labelTextStyle,
            ),
          ),
        )
      ],
    );
  }
}
