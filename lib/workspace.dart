import 'package:flutter/material.dart';
import 'package:waterpark_frontend/palette.dart';

class BoxWidget extends StatelessWidget {
  const BoxWidget({Key? key, required this.color}) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ColoredBox(
        color: color,
        child: Text("A"),
      ),
    );
  }
}

enum SplitWidgetDirection {
  horizontal,
  vertical,
}

class SplitWidgetSash extends StatelessWidget {
  const SplitWidgetSash({
    Key? key,
    required this.direction,
    required this.size,
  }) : super(key: key);

  final SplitWidgetDirection direction;
  final double size;

  @override
  Widget build(BuildContext context) {

    final Size extent = 
      direction == SplitWidgetDirection.horizontal ? 
      (Size.fromHeight(size)) :
       (Size.fromWidth(size));

    return SizedBox(
      width: extent.width,
      height: extent.height,
      child: ColoredBox(color: Palette.background),
    );
  }
}

class SplitWidget extends StatelessWidget {
  const SplitWidget({
    Key? key,
    required this.direction,
    required this.childA,
    required this.childB,
  }) : super(key: key);

  final SplitWidgetDirection direction;
  final Widget childA;
  final Widget childB;

  @override
  Widget build(BuildContext context) {
    if (direction == SplitWidgetDirection.horizontal) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            childA,
            SplitWidgetSash(
              direction: SplitWidgetDirection.horizontal,
              size: 10,
            ),
            childB,
          ],
        ),
      );

      // col
    } else {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            childA,
            SplitWidgetSash(
              direction: SplitWidgetDirection.vertical,
              size: 10,
            ),
            childB,
          ],
        ),
      );
    }
  }
}

class WorkSpaceWidget extends StatelessWidget {
  const WorkSpaceWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget a = BoxWidget(color: Palette.action);
    final Widget b = BoxWidget(color: Palette.actionSecondary);

    return SplitWidget(
      direction: SplitWidgetDirection.horizontal,
      childA: a,
      childB: b,
    );
  }
}
