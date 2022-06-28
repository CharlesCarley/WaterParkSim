import 'package:waterpark_frontend/state/node.dart';

class Tank extends Location {
  double height;
  double capacity;
  double level;

  Tank({
    required double x,
    required double y,
    required this.height,
    required this.capacity,
    required this.level,
  }) : super(x: x, y: y);
}

class SocketBits {
  static const int N = 0x01;
  static const int E = 0x02;
  static const int S = 0x04;
  static const int W = 0x08;
}

class Sock extends Node {
  int dir;
  double dx;
  double dy;

  Sock({
    required this.dir,
    required this.dx,
    required this.dy,
  });
}
