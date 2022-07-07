import '../simulation/state_execute.dart';
import 'common_state.dart';

class StateTree {
  final List<Node> code;
  final StateTreeExecutor _executor;

  /// Constructs an empty state tree
  StateTree.zero()
      : code = [],
        _executor = StateTreeExecutor.zero();

  /// Constructs a state tree from the supplied code.
  StateTree({required this.code}) : _executor = StateTreeExecutor.zero();

  /// Executes a single step
  void step(double ms) {
    _executor.step(ms);
  }
}
