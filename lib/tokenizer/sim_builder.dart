import 'package:waterpark/main.dart';
import 'package:waterpark/state/input_state.dart';
import 'package:waterpark/state/object_state.dart';
import 'package:waterpark/state/socket_state.dart';
import 'package:waterpark/state/tank_state.dart';
import 'package:waterpark/state/target_ids.dart';
import 'package:waterpark/util/double_utils.dart';
import 'package:waterpark/xml/parser.dart';
import '../xml/node.dart';

enum ObjectTags {
  page,
  input,
  tank,
  osock,
  isock,
}

class PrintLogger extends XmlParseLogger {
  @override
  void log(String message) {
    print(message);
  }
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
          }
        }
      }
    }
    return _stateObjects;
  }

  void _buildInputObject(XmlNode node) {
    InputObject? obj;
    if (node.contains("param")) {
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
      _stateObjects.add(obj);
      _buildSocketsForObjects(node, obj);
    }
  }

  void _buildTankObject(XmlNode node) {
    TankObject? obj;

    if (node.contains("param")) {
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
      _stateObjects.add(obj);
      _buildSocketsForObjects(node, obj);
    }
  }

  SockObject _buildBaseSock(XmlNode node, SimNode parent) {
    double x = 0, y = 0;
    int dir = 0;

    if (node.contains("param")) {
      var sl = node.asString("param").split(",");
      if (sl.length >= 3) {
        // dir,x,y

        dir = _parseDirection(sl[0]);
        x = DoubleUtils.fromString(sl[1]);
        y = DoubleUtils.fromString(sl[2]);
      }
    } else {
      x = node.asDouble("dx");
      y = node.asDouble("dy");
      dir = _parseDirection(
        node.asString("dir"),
      );
    }

    int signX = (dir & SocketBits.E) != 0 ? -1 : 1;
    int signY = (dir & SocketBits.S) != 0 ? -1 : 1;

    var obj = SockObject(
        dir: dir,
        dx: signX * x,
        dy: signY * y,
        parent: parent,
        target: _lookUpTargetState(node.asString("target")));

    if (node.name == ObjectTags.osock.index) {
      var id = node.asString("id");
      if (id.isNotEmpty) {
        _findSocket.putIfAbsent(id, () => obj);
      }
      _findSocket.putIfAbsent(id, () => obj);
    } else if (node.name == ObjectTags.isock.index) {
      var id = node.asString("link");
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
}
