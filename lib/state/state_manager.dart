import '../simulation/state_execute.dart';
import 'common_state.dart';

class StateTree {
  final List<Node> code;
  final StateTreeExecutor _executor;

  StateTree.zero()
      : code = [],
        _executor = StateTreeExecutor.zero();

  StateTree({required this.code}) : _executor = StateTreeExecutor.zero();

  StateTree.cloned({required this.code})
      : _executor = StateTreeExecutor(code: code) {
    Future.microtask(() {
      _executor.updateValues();
    });
  }

  void step(double durMs) {
    Future.microtask(() {
      _executor.step(durMs);
    });
  }
}
