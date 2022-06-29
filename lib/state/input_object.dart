import 'package:waterpark_frontend/state/node.dart';

class InputObject extends Location {
  double flowRate;

  InputObject({
    required double x,
    required double y,
    required this.flowRate,
  }):super(x: x, y: y);
}
