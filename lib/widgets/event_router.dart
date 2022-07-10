import 'package:flutter/material.dart';
import 'package:waterpark/state/settings_state.dart';
import '../logger.dart';
import '../state/state_tree.dart';
import 'event_dispatcher.dart';

class WorkSpaceEventReceiver {
  void onRun() {}
  void onDisplaySettings() {}
  void onDisplaySettingsClosed() {}
  void onStateTreeCompiled(StateTree stateTree) {}
  void onKey(RawKeyEvent key) {}
  void onHelp() {}
  void onHelpClosed() {}
  void onMessageLogged() {}
}

class WorkspaceEventDispatcher extends EventDispatcher<WorkSpaceEventReceiver> {
  String text = SettingsState.debugProg;
  late final XmlListLogger logger;

  Future notifyRun() {
    return Future.microtask(() {
      for (var receiver in receivers) {
        receiver.onRun();
      }
    });
  }

  Future notifyDisplaySettings() {
    return Future.microtask(() {
      for (var receiver in receivers) {
        receiver.onDisplaySettings();
      }
    });
  }

  Future notifyDisplaySettingsClosed() {
    return Future.microtask(() {
      for (var receiver in receivers) {
        receiver.onDisplaySettingsClosed();
      }
    });
  }

  Future notifyHelpClosed() {
    return Future.microtask(() {
      for (var receiver in receivers) {
        receiver.onHelpClosed();
      }
    });
  }

  Future notifyStateTreeCompiled(StateTree stateTree) {
    return Future.microtask(() {
      for (var receiver in receivers) {
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

  Future notifyHelp() {
    return Future.microtask(() {
      for (var receiver in receivers) {
        receiver.onHelp();
      }
    });
  }

  Future notifyMessageLogged() {
    return Future.microtask(() {
      for (var receiver in receivers) {
        receiver.onMessageLogged();
      }
    });
  }
}
