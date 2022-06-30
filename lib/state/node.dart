import 'package:flutter/material.dart';
import 'package:waterpark_frontend/palette.dart';
import 'package:waterpark_frontend/state/input_object.dart';
import 'package:waterpark_frontend/state/socket_object.dart';

import 'tank_object.dart';

class Node {
  List<SockObject> inputs = [];
  List<SockObject> outputs = [];

  get hasOutputs => outputs.isNotEmpty;
  get hasInputs => inputs.isNotEmpty;
}

class NodeManager extends Listenable {
  List<Node> _values = [];
  VoidCallback? onValueChanged;
  VoidCallback? onSimChanged;

  List<Node> nodes = [];

  get clearColor => Palette.background;
  bool _stopped = true;

  get stopped => _stopped;

  void apply(List<Node> evt) {
    _values.clear();
    _values = evt;

    Future.microtask(() => {updateValues()})
        .whenComplete(() => onValueChanged?.call());
  }

  List<Node> fetch() {
    return _values;
  }

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
    nodes = [];
    Node? prev;

    for (Node nd in _values) {
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
