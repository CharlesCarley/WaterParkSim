import '../palette.dart';
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


    }
  }

  void _filterTypeNodesOnStack(Stack<Node> stack, Stack<double> values, Node node) {
    if (node is InputObject) {
      values.push(node.flowRate);
    } else if (node is TankObject) {
      stack.push(node);
    }
  }
}
