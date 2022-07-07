import 'package:waterpark/state/socket_state.dart';

import '../state/common_state.dart';
import '../state/input_state.dart';
import '../state/tank_state.dart';
import '../util/stack.dart';

class StateTreeExecutor {
  final List<Node> code;

  StateTreeExecutor.zero() : code = [];

  StateTreeExecutor({required this.code}) {
    updateValues();
  }

  void updateValues() {}

  void step(double durMs) {
    Stack<Node> stack = Stack.zero();
    Stack<double> values = Stack.zero();

    for (Node node in code) {
      _filterTypeNodesOnStack(stack, values, node);

      if (values.isNotEmpty && node is SockObject) {
        double? v = values.top();
        if (v != null) {
          node.cacheValue(v);
        }
      }
    }
  }

  void _filterTypeNodesOnStack(
      Stack<Node> stack, Stack<double> values, Node node) {
    if (node is InputObject) {
      stack.push(node);
    } else if (node is TankObject) {
      stack.push(node);
    }
  }
}
