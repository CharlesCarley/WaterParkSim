import 'package:waterpark/state/input_state.dart';
import 'package:waterpark/state/common_state.dart';
import 'package:waterpark/state/socket_state.dart';
import 'package:waterpark/state/tank_state.dart';
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
    logger: PrintLogger(),
  );
  final List<Node> _stateObjects = [];

  final Map<String, SockObject> _findSocket = {};

  /// Interprets the supplied buffer as XML,
  /// then compiles a node state tree from the XML parse tree.
  /// Returns a linear sequence of all nodes in the tree.
  List<Node> compile(String buffer) {
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
    var obj = InputObject(
      x: node.attributeDouble("x"),
      y: node.attributeDouble("y"),
      flowRate: node.attributeDouble("rate"),
      state: node.attributeBool("state"),
    );

    _stateObjects.add(obj);
    _buildSocketsForObjects(node, obj);
  }

  void _buildTankObject(XmlNode node) {
    var obj = TankObject(
      x: node.attributeDouble("x"),
      y: node.attributeDouble("y"),
      height: node.attributeDouble("height"),
      capacity: node.attributeDouble("capacity"),
      level: node.attributeDouble("level"),
    );

    _stateObjects.add(obj);
    _buildSocketsForObjects(node, obj);
  }

  SockObject _buildBaseSock(XmlNode node) {
    int dir = _parseDirection(
      node.attributeString("dir"),
    );

    int signX = (dir & SocketBits.E) != 0 ? -1 : 1;
    int signY = (dir & SocketBits.S) != 0 ? -1 : 1;

    var obj = SockObject(
      dir: dir,
      dx: signX * node.attributeDouble("dx"),
      dy: signY * node.attributeDouble("dy"),
    );

    if (node.name == ObjectTags.osock.index) {
      var id = node.attributeString("id");
      if (id.isNotEmpty) {
        _findSocket.putIfAbsent(id, () => obj);
      }
      _findSocket.putIfAbsent(id, () => obj);
    } else if (node.name == ObjectTags.isock.index) {
      var id = node.attributeString("link");
      if (id.isNotEmpty && _findSocket.containsKey(id)) {
        SockObject? link = _findSocket[id];

        if (link != null) {
          link.addInput(obj);
        }
      }
    }

    _stateObjects.add(obj);
    return obj;
  }

  void _buildSocketsForObjects(XmlNode node, Node obj) {
    for (var child in node.children) {
      if (child.name == ObjectTags.isock.index) {
        var sock = _buildBaseSock(child);
        obj.inputs.add(sock);
      } else if (child.name == ObjectTags.osock.index) {
        var sock = _buildBaseSock(child);
        obj.outputs.add(sock);
      }
    }
  }

  // void _parseSock() {
  //   String a1 = _nextString();
  //   double a2 = _nextDouble();
  //   double a3 = _nextDouble();

  //   int dir = _parseDirection(a1);

  //   int signX = (dir & SocketBits.E) != 0 ? -1 : 1;
  //   int signY = (dir & SocketBits.S) != 0 ? -1 : 1;

  //   _stateObjects.add(SockObject(
  //     dir: dir,
  //     dx: signX * a2,
  //     dy: signY * a3,
  //   ));
  // }

  // void _parseTank() {
  //   double x = _nextDouble();
  //   double y = _nextDouble();
  //   double h = _nextDouble();
  //   double c = _nextDouble();
  //   double d = _nextDouble();
  //   _stateObjects.add(
  //     TankObject(x: x, y: y, height: h, capacity: c, level: d),
  //   );
  // }

  // void _parseInput() {
  //   double x = _nextDouble();
  //   double y = _nextDouble();
  //   double r = _nextDouble();
  //   _stateObjects.add(InputObject(x: x, y: y, flowRate: r, state: false));
  // }

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

  // ToggleObject? _findToggle() {
  //   for (int i = _stateObjects.length - 1; i >= 0; --i) {
  //     if (_stateObjects[i] is ToggleObject) {
  //       return _stateObjects[i] as ToggleObject;
  //     }
  //   }
  //   return null;
  // }

  // SockObject? _findSocket(int idx) {
  //   int loc = (_stateObjects.length) + idx;

  //   if (loc >= 0 && loc < _stateObjects.length) {
  //     if (_stateObjects[loc] is SockObject) {
  //       return _stateObjects[loc] as SockObject;
  //     }
  //   }
  //   return null;
  // }

  // void _parseState() {
  //   Token a1 = _nextToken();

  //   if (a1.isNumber) {
  //     ToggleObject? obj = _findToggle();
  //     if (obj != null) {
  //       obj.toggle = _number(a1.index) != 0;
  //     }
  //   } else if (a1.isIdentifier) {
  //     ToggleObject? obj = _findToggle();
  //     if (obj != null) {
  //       var val = _string(a1.index);
  //       obj.toggle = val == "yes" || val == "open";
  //     }
  //   }
  // }

  // void _parseLink() {
  //   // enforce the limit if it is not found
  //   var max = _stateObjects.length;

  //   var offsA = _nextInteger(def: max);
  //   var offsB = _nextInteger(def: max);

  //   SockObject? a = _findSocket(offsA);
  //   SockObject? b = _findSocket(offsB);

  //   if (b != null && a != null) {
  //     b.addInput(a);
  //   }
  // }
}
