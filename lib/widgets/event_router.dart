import 'package:flutter/material.dart';
import 'package:waterpark_frontend/state/settings_state.dart';

import '../state/state_manager.dart';
import 'event_dispatcher.dart';

class WorkSpaceEventReceiver {
  void onRun(){}
  void onDisplaySettings(){}
  void onDisplaySettingsClosed(){}
  void onStateTreeCompiled(StateTree stateTree){}
  void onKey(RawKeyEvent key){}
}



class WorkspaceEventDispatcher extends EventDispatcher<WorkSpaceEventReceiver> {

  String text = SettingsState.debugProg;

  Future notifyRun() {
    return Future.microtask(() {
      for (var receiver in receivers) {
        // print("${receiver} -> onRun");
        receiver.onRun();
      }
    });
  }

  Future notifyDisplaySettings() {
    return Future.microtask(() {
      for (var receiver in receivers) {
        // print("${receiver} -> onDisplaySettings");
        receiver.onDisplaySettings();
      }
    });
  }
  Future notifyDisplaySettingsClosed() {
    return Future.microtask(() {
      for (var receiver in receivers) {
        // print("${receiver} -> onDisplaySettingsClosed");
        receiver.onDisplaySettingsClosed();
      }
    });
  }
  Future notifyStateTreeCompiled(StateTree stateTree) {
    return Future.microtask(() {
      for (var receiver in receivers) {
        // print("${receiver} -> onStateTreeCompiled");
        receiver.onStateTreeCompiled(stateTree);
      }
    });
  }



  Future notifyKey(RawKeyEvent key) {
    return Future.microtask(() {
      for (var receiver in receivers) {
        receiver.onKey(key);
      }
    });
  }
}
