import '../metrics.dart';
import 'rect_state.dart';

class TankObject extends RectState {
  double height;
  double capacity;
  double level;

  TankObject({
    required double x,
    required double y,
    required this.height,
    required this.capacity,
    required this.level,
  }) : super(x: x, y: y, w: Metrics.tankWidth, h: Metrics.tankHeight);
}
