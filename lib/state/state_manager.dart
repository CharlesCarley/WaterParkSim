import 'package:flutter/material.dart';

import '../palette.dart';
import 'common_state.dart';
import 'input_state.dart';
import 'socket_state.dart';
import 'tank_state.dart';

abstract class StateTreeEventReceiver {
  void onRun();
  void onDisplaySettings();
}

class StateTreeEventDispatcher {
  List<StateTreeEventReceiver> receivers = <StateTreeEventReceiver>[];

  void subscribe(StateTreeEventReceiver receiver) {
    if (!receivers.contains(receiver)) {
      receivers.remove(receiver);
    }
  }

  void unsubscribe(StateTreeEventReceiver receiver) {
    if (receivers.contains(receiver)) {
      receivers.remove(receiver);
    }
  }

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
}

class StateTree extends Listenable {
  final List<Node> code;
  VoidCallback? onValueChanged;
  VoidCallback? onSimChanged;

  List<Node> _nodes = [];

  get  nodes =>_nodes;

  StateTree({required this.code});
  StateTree.zero() : code = [];

  get clearColor => Palette.background;
  bool _stopped = true;

  get stopped => _stopped;

  @override
  void addListener(VoidCallback listener) {
    onValueChanged = listener;
  }

  @override
  void removeListener(VoidCallback listener) {
    onValueChanged = null;
  }

  void launchSim() {
    Future.microtask(() => simLoop()).whenComplete(() {
      onSimChanged?.call();
      _stopped = true;
    });
  }

  void simLoop() {
    while (!stopped) {
      for (Node nd in nodes) {
        if (nd is InputObject) {
          processInputNode(nd);
        }
      }
    }
  }

  void updateValues() {
    _nodes = [];
    Node? prev;

    for (Node nd in code) {
      if (prev != null && nd is SockObject) {
        for (var iSock in nd.inputs) {
          prev.inputs.add(iSock);
        }
        for (var oSock in nd.outputs) {
          prev.outputs.add(oSock);
        }
      }

      if (nd is InputObject) {
        nodes.add(nd);
        prev = nd;
      } else if (nd is TankObject) {
        nodes.add(nd);
        prev = nd;
      } else {
        prev = null;
      }
    }
  }

  void processInputNode(InputObject nd) {
    if (nd.toggle) {
      for (var iSock in nd.inputs) {
        nd.flowRate += iSock.getCache();
      }
      for (var oSock in nd.outputs) {
        oSock.cacheValue(nd.flowRate);
      }
    }
  }
}
