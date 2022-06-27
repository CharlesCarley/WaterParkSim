import 'package:waterpark_frontend/state/node.dart';

class Tank extends Node {
  double x;
  double y;
  double height;
  double capacity;
  double level;

  Tank({
    required this.x,
    required this.y,
    required this.height,
    required this.capacity,
    required this.level,
  });
}
