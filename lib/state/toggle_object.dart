import 'location.dart';

class ToggleObject extends Location {
  bool toggle;

  ToggleObject({
    required double x,
    required double y,
    required double w,
    required double h,
    required this.toggle,
  }) : super(x: x, y: y, w: w, h: h);
}
