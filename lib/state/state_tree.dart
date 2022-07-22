import '../simulation/state_execute.dart';
import 'object_state.dart';

// TODO: merge this with the StateTreeExecutor
class StateTree {
  final List<SimObject> code;
  final StateTreeExecutor _executor;
  final double tick;

  /// Constructs an empty state tree
  StateTree.zero()
      : code = [],
        tick = 1000,
        _executor = StateTreeExecutor.zero();

  /// Constructs a state tree from the supplied code.
  StateTree({required this.code, required this.tick})
      : _executor = StateTreeExecutor(code: code, rate: tick);

  /// Executes a single step
  void step(double ms) {
    _executor.step(ms);
  }
}
