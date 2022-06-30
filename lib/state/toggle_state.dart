import 'rect_state.dart';

class ToggleObject extends RectState {
  bool toggle;

  ToggleObject({
    required double x,
    required double y,
    required double w,
    required double h,
    required this.toggle,
  }) : super(x: x, y: y, w: w, h: h);
}
