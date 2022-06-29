import 'node.dart';

class Location extends Node{
  double x;
  double y;
  double w;
  double h;

  Location({required this.x, required this.y, required this.w, required this.h});
}


class RunState
{
  bool on;
  RunState({required this.on});
} 