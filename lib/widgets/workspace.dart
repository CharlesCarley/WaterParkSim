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
import 'package:waterpark_frontend/palette.dart';

import '../dashboard/stacked_canvas.dart';

class BoxWidget extends StatelessWidget {
  const BoxWidget({
    Key? key,
    required this.color,
    required this.child,
  }) : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: child,
      ),
    );
  }
}

class SplitWidgetContainer extends StatelessWidget {
  const SplitWidgetContainer({
    Key? key,
    required this.extent,
    required this.offset,
    required this.child,
  }) : super(key: key);

  final Size extent;
  final Offset offset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

enum SplitWidgetDirection {
  horizontal,
  vertical,
}

class SplitWidgetSash extends StatefulWidget {
  const SplitWidgetSash({
    Key? key,
    required this.direction,
    required this.size,
    required this.color,
  }) : super(key: key);

  final SplitWidgetDirection direction;
  final double size;
  final Color color;

  @override
  State<SplitWidgetSash> createState() => _SplitWidgetSashState();
}

class _SplitWidgetSashState extends State<SplitWidgetSash> {
  @override
  Widget build(BuildContext context) {
    final Size extent = widget.direction == SplitWidgetDirection.horizontal
        ? (Size.fromHeight(widget.size))
        : (Size.fromWidth(widget.size));

    return SizedBox(
      width: extent.width,
      height: extent.height,
      child: ColoredBox(color: widget.color),
    );
  }
}

class SplitWidget extends StatefulWidget {
  const SplitWidget({
    Key? key,
    required this.direction,
    required this.childA,
    required this.childB,
    required this.initialSplit,
  }) : super(key: key);

  final SplitWidgetDirection direction;
  final Widget childA;
  final Widget childB;
  final double initialSplit;

  @override
  State<SplitWidget> createState() => _SplitWidgetState();
}

class _SplitWidgetState extends State<SplitWidget> {
  final double size = 6;
  double splitPosition = -1;
  bool captured = false;
  bool change = false;

  void _handlePointerUp() {
    setState(() {
      captured = false;
      change = false;
    });
  }

  void _handlePointerDown(double a, double b) {
    captured = b >= a && b <= a + size;
  }

  void _handleHover(double a, double b) {
    if ((b >= a && b <= (a + size))) {
      setState(() {
        change = true;
      });
    } else {
      setState(() {
        change = false;
      });
    }
  }

  List<Widget> _extractSplit(Size extent, SplitWidgetDirection dir) {
    return [
      SizedBox(
        width: extent.width,
        height: extent.height,
        child: widget.childA,
      ),
      SplitWidgetSash(
        direction: dir,
        size: size,
        color: change ? Palette.wireChange : Palette.darkGrey,
      ),
      Expanded(child: widget.childB),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    if (splitPosition < 0) {
      splitPosition = widget.initialSplit;
    }

    if (widget.direction == SplitWidgetDirection.horizontal) {
      final double height = screenSize.height - size;
      final double bottomA = Metrics.clamp(
        (height * splitPosition).roundToDouble(),
        0,
        height,
      );

      final Size extent = Size.fromHeight(bottomA);

      return Listener(
        onPointerUp: (event) {
          _handlePointerUp();
        },
        onPointerDown: (event) {
          _handlePointerDown(bottomA, event.position.dy);
        },
        onPointerHover: (event) {
          _handleHover(bottomA, event.position.dy);
        },
        onPointerMove: (event) {
          setState(() {
            if (captured) {
              splitPosition = event.position.dy / height;
            }
          });
        },
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _extractSplit(extent, SplitWidgetDirection.horizontal)),
      );

      // col
    } else {
      final double width = screenSize.width - size;
      final double rightA = Metrics.clamp(
        (width * splitPosition).roundToDouble(),
        0,
        width,
      );
      final Size extent = Size.fromWidth(rightA);
      return Listener(
        onPointerUp: (event) {
          _handlePointerUp();
        },
        onPointerDown: (event) {
          _handlePointerDown(rightA, event.position.dx);
        },
        onPointerHover: (event) {
          _handleHover(rightA, event.position.dx);
        },
        onPointerMove: (event) {
          setState(() {
            if (captured) {
              splitPosition = event.position.dx / width;
            }
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _extractSplit(extent, SplitWidgetDirection.vertical),
        ),
      );
    }
  }
}
