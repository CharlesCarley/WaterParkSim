import 'package:waterpark/state/socket_state.dart';
import 'package:waterpark/state/target_ids.dart';
import '../state/object_state.dart';
import '../state/input_state.dart';
import '../state/tank_state.dart';

class StateTreeExecutor {
  final List<SimObject> code;

  StateTreeExecutor.zero() : code = [];

  StateTreeExecutor({required this.code});

  void step(double dur) {
    dur /= 16;

    for (SimObject node in code) {
      bool sockType = node is SockObject;
      if (sockType) continue;

      if (node is InputObject) {
        _processInputObject(dur, node);
      } else if (node is TankObject) {
        _processTankObject(dur, node);
      }
    }
  }

  void _processInputObject(double dur, InputObject node) {
    if (node.toggle) {
      for (var osock in node.outputs) {
        osock.cacheValue(node.flowRate);
      }
    }
  }

  void _processTankObject(double dur, TankObject node) {
    double bbl = node.toBarrels();

    for (var isock in node.inputs) {
      if (isock.link != null) {
        bool pullCache = isock.target == SimTargetId.dump.index ||
            isock.target == SimTargetId.eqManifold.index;
        if (pullCache) {
          double v = isock.link!.getCache();
          bbl += v / dur;
        }
      }
    }

    for (var osock in node.outputs) {
      if (osock.target == SimTargetId.spill.index) {
        if (node.toLevel(bbl) > node.sockHeight(osock)) {
          bbl -= 6 / dur;
          osock.cacheValue(6);
        }
      }

      if (osock.target == SimTargetId.eqManifold.index) {
        if (node.toLevel(bbl) > node.sockHeight(osock)) {
          bbl -= 3 / dur;
          osock.cacheValue(3);
        }
      }
    }
    node.level = node.toLevel(bbl);
  }
}
