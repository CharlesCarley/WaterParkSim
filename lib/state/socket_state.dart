import 'object_state.dart';

class SocketBits {
  static const int N = 0x01;
  static const int E = 0x02;
  static const int S = 0x04;
  static const int W = 0x08;
}

class SockObject extends SimObject {
  final int dir;
  final double dx;
  final double dy;
  final SimNode parent;
  final int target;
  double ax = 0;
  double ay = 0;
  SockObject? link;
  final List<SockObject> fromLinks = [];
  final List<double> _cache = [];

  SockObject({
    required this.dir,
    required this.dx,
    required this.dy,
    required this.parent,
    required this.target,
  });

  double getCache() {
    double v = 0;
    if (_cache.isNotEmpty) {
      v = _cache.last;
      _cache.removeLast();
    }
    return v;
  }

  void cacheValue(double v) {
    _cache.add(v);
  }

  void connect(SockObject obj) {
    link = obj;
    obj.fromLinks.add(this);
  }
}
