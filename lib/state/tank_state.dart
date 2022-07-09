import 'package:waterpark/state/socket_state.dart';

import '../util/double_utils.dart';
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
        super(
            x: x,
            y: y,
            w: SettingsState.tankWidth,
            h: SettingsState.tankHeight);

  @override
  void onSocketAdded(SockObject sock, bool isInput) {
    if (!_hasEqualizationTarget) {
      _hasEqualizationTarget = sock.target == SimTargetId.eq.index;
    }
  }

  double toLevel(double bbl) {
    if (capacity <= 0 || height <= 0) {
      return 0;
    }

    return bbl / (capacity / height);
  }

  double toBarrels() {
    if (capacity <= 0 || height <= 0) {
      return 0;
    }

    return level * (capacity / height);
  }

  double hpp() {
    if (SettingsState.tankHeight <= 0) return 0;
    return (height / SettingsState.tankHeight);
  }

  double sockHeight(SockObject obj) {
    return DoubleUtils.abs(y + h - obj.ay) * hpp();
  }

  void addBarrels(double bbl) {
    var cur = toBarrels();
    cur += bbl;
    level = toLevel(cur);
  }

  void delBarrels(double bbl) {
    var cur = toBarrels();
    cur -= bbl;
    level = toLevel(cur);
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
