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

  List<double> _cache = [];

  SockObject({
    required this.dir,
    required this.dx,
    required this.dy,
  });

  void addInput(SockObject? a) {
    if (a != null) {
      // !should be unique
      inputs.add(a);
      a.outputs.add(this);
    }
  }

  List<SockObject> getOutputs() {
    return outputs;
  }

  double getCache() {
    double v = 0;
    if (_cache.isNotEmpty)
    {
      v = _cache.last;
      _cache.removeLast();
    }
    return v;
  }

  void cacheValue(double v) {
    _cache.add(v);
  }
}
