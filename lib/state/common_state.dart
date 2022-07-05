import 'socket_state.dart';

class Node {
  final List<SockObject> inputs = [];
  final List<SockObject> outputs = [];

  void clear()
  {
    inputs.clear();
    outputs.clear();
  }

  get hasOutputs => outputs.isNotEmpty;
  get hasInputs => inputs.isNotEmpty;
}
