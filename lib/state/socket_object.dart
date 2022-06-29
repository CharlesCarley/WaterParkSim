import 'node.dart';

class SocketBits {
  static const int N = 0x01;
  static const int E = 0x02;
  static const int S = 0x04;
  static const int W = 0x08;
}

class SockObject extends Node {
  int dir;
  double dx;
  double dy;

  SockObject({
    required this.dir,
    required this.dx,
    required this.dy,
  });
}
