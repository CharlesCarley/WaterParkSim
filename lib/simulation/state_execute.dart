import 'package:waterpark/state/socket_state.dart';

import '../state/common_state.dart';
import '../state/input_state.dart';
import '../state/tank_state.dart';

class StateTreeExecutor {
  final List<Node> code;

  StateTreeExecutor.zero() : code = [];

  StateTreeExecutor({required this.code}) {
    updateValues();
  }

  void updateValues() {}

  void step(double dur) {
    for (Node node in code) {
      bool sockType = node is SockObject;
      if (sockType) continue;

      if (node is InputObject) {
        _processInputObject(node);
      } else if (node is TankObject) {
        _processTankObject(node);
      }
    }
  }

  void _processInputObject(InputObject node) {
    if (node.toggle) {
      for (var osock in node.outputs) {
        osock.cacheValue(node.flowRate);
      }
    }
  }

  void _processTankObject(TankObject node) {
    for (var isock in node.inputs) {
      double v = isock.getCache();
      node.level += v;
    }
  }
}
