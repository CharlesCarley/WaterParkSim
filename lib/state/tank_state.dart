import '../util/double_utils.dart';
import 'manifold_utils.dart';
import 'socket_state.dart';
import 'object_state.dart';
import 'settings_state.dart';
import 'target_ids.dart';

class TankObject extends SimNode {
  double height;
  double capacity;
  double level;
  bool _hasEqualizationTarget;

  TankObject({
    required double x,
    required double y,
    required this.height,
    required this.capacity,
    required this.level,
  })  : _hasEqualizationTarget = false,
        super(x: x, y: y, w: Settings.tankWidth, h: Settings.tankHeight) {
    if (height <= 0) height = 1;
  }

  @override
  void onSocketAdded(SockObject sock, bool isInput) {
    if (!_hasEqualizationTarget) {
      _hasEqualizationTarget = sock.target == SimTargetId.eq.index;
    }
  }

  double get psi => level / ManifoldUtils.atmosphereFt;
  double get left => x;
  double get right => x + w;
  double get barrelsPerFoot =>
      (capacity <= 0 || height <= 0) ? 0 : capacity / height;
  double get barrelsPerInch =>
      (capacity <= 0 || height <= 0) ? 0 : capacity / (12 * height);
  double get feetPerPixel =>
      (Settings.tankHeight <= 0) ? 0 : height / Settings.tankHeight;

  double get barrels => (level * barrelsPerFoot);

  /// Get the total number of fluid barrels in the tank rounded up
  double get barrelsRu => (level * barrelsPerFoot).ceilToDouble();

  double toLevel(double bbl) {
    double bpf = barrelsPerFoot;
    if (bpf > 0) return bbl / bpf;
    return 0;
  }

  double sockHeight(SockObject obj) {
    return DoubleUtils.abs(y + h - obj.ay) * feetPerPixel;
  }

  void addBarrels(double bbl) {
    level = toLevel(barrels + bbl);
  }

  void delBarrels(double bbl) {
    level = toLevel(barrels - bbl);
  }

  bool canEqualize() {
    return _hasEqualizationTarget;
  }

  double equalizeHeight() {
    double p = height;

    for (var sock in inputs) {
      if (sock.link != null) {
        if (sock.link!.target == SimTargetId.eq.index) {
          p = DoubleUtils.min(p, sockHeight(sock));
        }
      }
    }

    for (var sock in outputs) {
      if (sock.target == SimTargetId.eq.index) {
        p = DoubleUtils.min(p, sockHeight(sock));
      }
    }
    return p;
  }
}
