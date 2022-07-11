import 'package:flutter/material.dart';
import 'package:waterpark/metrics.dart';
import 'package:waterpark/palette.dart';
import 'package:waterpark/state/settings_state.dart';
import 'package:waterpark/util/double_utils.dart';


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

  Size _screenSize = Size.zero;

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
        color: change ? Palette.wireChange : Palette.background,
      ),
      Expanded(child: widget.childB),
    ];
  }

  Size _getSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = _getSize(context);
    _screenSize = Size(
      screenSize.width,
      screenSize.height - Metrics.toolBarSize,
    );

    if (splitPosition < 0) {
      splitPosition = widget.initialSplit;
    }

    if (widget.direction == SplitWidgetDirection.horizontal) {
      var height = _screenSize.height - size;
      var bottomA = DoubleUtils.lim(
        (height * splitPosition).roundToDouble(),
        0,
        height,
      );

      var extent = Size.fromHeight(bottomA);

      return _listenY(
        bottomA,
        height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _extractSplit(
            extent,
            SplitWidgetDirection.horizontal,
          ),
        ),
      );

      // col
    } else {
      var width = _screenSize.width - size;
      var rightA = DoubleUtils.lim(
        (width * splitPosition).roundToDouble(),
        0,
        width,
      );
      var extent = Size.fromWidth(rightA);

      return _listenX(
        rightA,
        width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _extractSplit(
            extent,
            SplitWidgetDirection.vertical,
          ),
        ),
      );
    }
  }

  Listener _listenX(double sash, double width, {Widget? child}) {
    return Listener(
      onPointerUp: (event) {
        _handlePointerUp();
      },
      onPointerDown: (event) {
        _handlePointerDown(sash, event.position.dx);
      },
      onPointerHover: (event) {
        _handleHover(sash, event.position.dx);
      },
      onPointerMove: (event) {
        setState(() {
          if (captured) {
            splitPosition = event.position.dx / width;
            SettingsState.sashPos = splitPosition;
          }
        });
      },
      child: child,
    );
  }

  Listener _listenY(double sash, double height, {Widget? child}) {
    return Listener(
      onPointerUp: (event) {
        _handlePointerUp();
      },
      onPointerDown: (event) {
        _handlePointerDown(sash, event.position.dy - Metrics.toolBarSize);
      },
      onPointerHover: (event) {
        _handleHover(sash, event.position.dy - Metrics.toolBarSize);
      },
      onPointerMove: (event) {
        setState(() {
          if (captured) {
            splitPosition = (event.position.dy - Metrics.toolBarSize) / height;
          }
        });
      },
      child: child,
    );
  }
}
