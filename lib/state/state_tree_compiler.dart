import 'input_state.dart';
import 'manifold_utils.dart';
import 'object_state.dart';
import 'pump_state.dart';
import 'socket_state.dart';
import 'tank_state.dart';
import 'target_ids.dart';

import '../main.dart';

import '../util/double_utils.dart';
import '../xml/parser.dart';
import '../xml/node.dart';

/// Definition for used XML tags.
/// The XML parser will map each string name to the corresponding enum index.
enum ObjectTags {
  page,
  manifold,
  input,
  tank,
  osock,
  isock,
  trigger,
  pump,
}

class StateTreeCompiler {
  final XmlParser _parser = XmlParser(
    ObjectTags.values.asNameMap().keys.toList(),
    logger: logger,
  );
  final List<SimObject> _stateObjects = [];
  final List<String> _targetStates =
      SimTargetId.values.asNameMap().keys.toList();

  final Map<String, SockObject> _findSocket = {};
  final Map<String, SimObject> _findObject = {};

  /// Interprets the supplied buffer as XML,
  /// then compiles a node state tree from the XML parse tree.
  /// Returns a linear sequence of all nodes in the tree.
  List<SimObject> compile(String buffer) {
    _stateObjects.clear();
    _findSocket.clear();
    _parser.parse(buffer);

    if (_parser.hasRoot) {
      if (_parser.root.name == 0) {
        for (XmlNode node in _parser.root.children) {
          if (node.name == ObjectTags.input.index) {
            _buildInputObject(node);
          } else if (node.name == ObjectTags.tank.index) {
            _buildTankObject(node);
          } else if (node.name == ObjectTags.manifold.index) {
            _setManifold(node);
          } else if (node.name == ObjectTags.pump.index) {
            _buildPumpObject(node);
          }
        }
      }
    }
    return _stateObjects;
  }

  /// Maps objects with an id attribute for later retrieval.
  void _storeObject(XmlNode node, SimObject obj) {
    if (node.hasAttribute("id")) {
      var id = node.asString("id");
      if (id.isNotEmpty) {
        _findObject.putIfAbsent(id, () => obj);
      }
    }
  }

  void _buildInputObject(XmlNode node) {
    InputObject? obj;
    if (node.hasAttribute("param")) {
      // packed as: x, y, rate
      var list = node.asListDouble("param");
      if (list.length >= 3) {
        obj = InputObject(
            x: list[0],
            y: list[1],
            flowRate: list[2],
            state: node.asBool("state"));
      }
    } else {
      obj = InputObject(
        x: node.asDouble("x"),
        y: node.asDouble("y"),
        flowRate: node.asDouble("rate"),
        state: node.asBool("state"),
      );
    }

    if (obj != null) {
      _onObjectBuilt(node, obj);
    }
  }

  void _buildTankObject(XmlNode node) {
    TankObject? obj;

    if (node.hasAttribute("param")) {
      // packed as: x, y, height, capacity, level
      var list = node.asListDouble("param");
      if (list.length >= 5) {
        obj = TankObject(
          x: list[0],
          y: list[1],
          height: list[2],
          capacity: list[3],
          level: list[4],
        );
      }
    } else {
      obj = TankObject(
        x: node.asDouble("x"),
        y: node.asDouble("y"),
        height: node.asDouble("height"),
        capacity: node.asDouble("capacity"),
        level: node.asDouble("level"),
      );
    }
    if (obj != null) {
      _onObjectBuilt(node, obj);
    }
  }

  void _buildPumpObject(XmlNode node) {
    PumpObject? obj;
    if (node.hasAttribute("param")) {
      // packed as: x, y, rate
      var list = node.asListDouble("param");
      if (list.length >= 3) {
        obj = PumpObject(
            x: list[0],
            y: list[1],
            pumpRate: list[2],
            state: node.asBool("state"));
      }
    } else {
      obj = PumpObject(
        x: node.asDouble("x"),
        y: node.asDouble("y"),
        pumpRate: node.asDouble("rate"),
        state: node.asBool("state"),
      );
    }

    if (obj != null) {
      // check for triggers
      if (node.hasChildren) {
        var triggers = node.childrenOf(ObjectTags.trigger.index);
        if (triggers.isNotEmpty) {
          _linkTrigger(obj, triggers[0]);
        }
      }

      _onObjectBuilt(node, obj);
    }
  }

  void _linkTrigger(PumpObject obj, XmlNode trigger) {
    var link = trigger.asString("link");
    if (link.isNotEmpty) {
      if (_findObject.containsKey(link)) {
        SimObject? linkObj = _findObject[link];

        if (linkObj != null && linkObj is TankObject) {
          obj.levelMonitor = linkObj;
          obj.levelStart = trigger.asDouble("start");
          obj.levelStop = trigger.asDouble("stop");
        } else {
          logger.log("the supplied object link $link "
              "is invalid or bound to an object that is not a tank.");
        }
      } else {
        logger.log("object with the id $link was not found.");
      }
    }
  }

  /// Stores and builds extra information common to all nodes.
  void _onObjectBuilt(XmlNode node, SimNode obj) {
    _storeObject(node, obj);

    _stateObjects.add(obj);
    _buildSocketsForObjects(node, obj);
  }

  SockObject _buildBaseSock(XmlNode sock, SimNode parent) {
    double x = 0, y = 0;
    int dir = 0;

    if (sock.hasAttribute("param")) {
      // packed as: dir, x, y
      var sl = sock.asString("param").split(",");
      if (sl.length >= 3) {
        dir = _parseDirection(sl[0]);
        x = DoubleUtils.fromString(sl[1]);
        y = DoubleUtils.fromString(sl[2]);
      }
    } else {
      x = sock.asDouble("dx");
      y = sock.asDouble("dy");
      dir = _parseDirection(
        sock.asString("dir"),
      );
    }

    int signX = (dir & SocketBits.E) != 0 ? -1 : 1;
    int signY = (dir & SocketBits.S) != 0 ? -1 : 1;

    var obj = SockObject(
        dir: dir,
        dx: signX * x,
        dy: signY * y,
        parent: parent,
        target: _lookUpTargetState(sock.asString("target")));

    if (sock.name == ObjectTags.osock.index) {
      var id = sock.asString("id");
      if (id.isNotEmpty) {
        _findSocket.putIfAbsent(id, () => obj);
      }
    } else if (sock.name == ObjectTags.isock.index) {
      var id = sock.asString("link");
      if (id.isNotEmpty && _findSocket.containsKey(id)) {
        SockObject? link = _findSocket[id];
        if (link != null) {
          obj.connect(link);
        }
      }
    }

    _stateObjects.add(obj);
    return obj;
  }

  void _buildSocketsForObjects(XmlNode node, SimNode obj) {
    for (var child in node.children) {
      if (child.name == ObjectTags.isock.index) {
        var sock = _buildBaseSock(child, obj);
        obj.addSocket(sock, true);
      } else if (child.name == ObjectTags.osock.index) {
        var sock = _buildBaseSock(child, obj);
        obj.addSocket(sock, false);
      }
    }
  }

  int _parseDirection(String string) {
    int dir = 0;
    for (int i = 0; i < string.length && i < 2; ++i) {
      int unit = string.codeUnitAt(i);
      switch (unit) {
        case 0x4E: // N
        case 0x6E: // n
          dir |= SocketBits.N;
          break;
        case 0x45: // E
        case 0x65: // e
          dir |= SocketBits.E;
          break;
        case 0x53: // S
        case 0x73: // s
          dir |= SocketBits.S;
          break;
        case 0x57: // W
        case 0x77: // w
          dir |= SocketBits.W;
          break;
      }
    }
    if (dir == 0) dir |= SocketBits.N;
    return dir;
  }

  int _lookUpTargetState(String target) {
    return _targetStates.indexOf(target);
  }

  void _setManifold(XmlNode node) {
    ManifoldUtils.diameter = DoubleUtils.lim(
      node.asDouble("dia", def: 4),
      1,
      200,
    );
    ManifoldUtils.velocity = DoubleUtils.lim(
      node.asDouble("vel", def: 1),
      0,
      50,
    );

    ManifoldUtils.calculateMaxFlow();
  }
}
