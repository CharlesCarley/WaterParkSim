import 'socket_state.dart';

class Node {
  List<SockObject> inputs = [];
  List<SockObject> outputs = [];

  get hasOutputs => outputs.isNotEmpty;
  get hasInputs => inputs.isNotEmpty;
}
