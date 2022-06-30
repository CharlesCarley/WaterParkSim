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
  double ax = 0;
  double ay = 0;

  List<SockObject> _inputs = [];
  List<SockObject> _outputs = [];

  SockObject({
    required this.dir,
    required this.dx,
    required this.dy,
  });

  bool get hasOutputs => _outputs.isNotEmpty;

  void addInput(SockObject? a) {
    if (a != null)
    {
      print("Added Input$a");
      // !should be unique
      _inputs.add(a);
      _inputs.last._outputs.add(this);
    }
  }

  List<SockObject> getOutputs() {return _outputs;}
}
