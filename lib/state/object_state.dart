import 'package:waterpark/state/socket_state.dart';

class SimObject {}

class SimNode extends SimObject {
  double x;
  double y;
  double w;
  double h;

  SimNode({
    required this.x,
    required this.y,
    required this.w,
    required this.h,
  });

  final List<SockObject> inputs = [];
  final List<SockObject> outputs = [];

  bool get hasOutputs => outputs.isNotEmpty;
  bool get hasInputs => inputs.isNotEmpty;

  void clear() {
    inputs.clear();
    outputs.clear();
  }

  void addSocket(SockObject? a, bool isInput) {
    if (a != null) {
      if (isInput) {
        inputs.add(a);
      } else {
        outputs.add(a);
      }
    }
  }
}
