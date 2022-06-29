import '../metrics.dart';
import 'location.dart';

class TankObject extends Location {
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
