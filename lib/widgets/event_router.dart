import '../state/state_manager.dart';
import 'event_dispatcher.dart';

abstract class WorkSpaceEventReceiver {
  void onRun();
  void onDisplaySettings();
  void onStateTreeCompiled(StateTree stateTree);
}

class WorkspaceEventDispatcher extends EventDispatcher<WorkSpaceEventReceiver> {
  Future notifyRun() {
    return Future.microtask(() {
      for (var receiver in receivers) {
        print("${receiver} -> onRun");
        receiver.onRun();
      }
    });
  }

  Future notifyDisplaySettings() {
    return Future.microtask(() {
      for (var receiver in receivers) {
        print("${receiver} -> onDisplaySettings");
        receiver.onDisplaySettings();
      }
    });
  }

  Future notifyStateTreeCompiled(StateTree stateTree) {
    return Future.microtask(() {
      for (var receiver in receivers) {
        print("${receiver} -> onStateTreeCompiled");
        receiver.onStateTreeCompiled(stateTree);
      }
    });
  }
}
