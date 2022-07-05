import 'package:waterpark/state/input_state.dart';
import 'package:waterpark/state/common_state.dart';
import 'package:waterpark/state/tank_state.dart';
import 'package:waterpark/state/toggle_state.dart';

import '../state/socket_state.dart';
import 'tokenizer.dart';

/// Utility class to compile a state tree.
class StateTreeCompiler {
  final Tokenizer _tokenizer = Tokenizer();

  /// Compiles the supplied buffer.
  List<Node> compile(String buffer) {
    _position = 0;
    _tokens = _tokenizer.tokenize(buffer);
    _stateObjects = [];

    bool running = true;
    do {
      Token it = _nextToken();
      if (it.isKeyword) {
        _readKeyword(it);
      } else {
        running = false;
      }
    } while (running);

    return _stateObjects;
  }

  void _readKeyword(Token current) {
    String kw = _tokenizer.getKeyword(current.index);
    if (kw.isEmpty) return;

    if (kw.compareTo("tank") == 0) {
      _parseTank();
    } else if (kw.compareTo("sock") == 0) {
      _parseSock();
    } else if (kw.compareTo("input") == 0) {
      _parseInput();
    } else if (kw.compareTo("state") == 0) {
      _parseState();
    } else if (kw.compareTo("link") == 0) {
      _parseLink();
    }
  }

  List<Token> _tokens = [];
  int _position = 0;
  List<Node> _stateObjects = [];

  Token _nextToken() {
    int loc = _position;
    if (loc < 0 || loc >= _tokens.length) {
      return Token.fromId(TokenId.none);
    }
    ++_position;
    return _tokens[loc];
  }

  double _number(int idx, {double def = 0.0}) {
    return _tokenizer.getNumber(idx, def: def);
  }

  String _string(int idx, {String def = ""}) {
    return _tokenizer.getIdentifier(idx, def: def);
  }

  String _keyword(int idx, {String def = ""}) {
    return _tokenizer.getKeyword(idx, def: def);
  }

  double _nextDouble({double def = 0}) {
    Token a1 = _nextToken();
    if (a1.isNumber) return _number(a1.index, def: def);
    return def;
  }

  int _nextInteger({int def = 0}) {
    return _nextDouble(def: def.toDouble()).toInt();
  }

  String _nextString({String def = ""}) {
    Token a1 = _nextToken();
    if (a1.isIdentifier) return _string(a1.index, def: def);
    if (a1.isKeyword) return _keyword(a1.index, def: def);
    return def;
  }

  void _parseSock() {
    String a1 = _nextString();
    double a2 = _nextDouble();
    double a3 = _nextDouble();

    int dir = _parseDirection(a1);

    int signX = (dir & SocketBits.E) != 0 ? -1 : 1;
    int signY = (dir & SocketBits.S) != 0 ? -1 : 1;

    _stateObjects.add(SockObject(
      dir: dir,
      dx: signX * a2,
      dy: signY * a3,
    ));
  }

  void _parseTank() {
    double x = _nextDouble();
    double y = _nextDouble();
    double h = _nextDouble();
    double c = _nextDouble();
    double d = _nextDouble();
    _stateObjects.add(
      TankObject(x: x, y: y, height: h, capacity: c, level: d),
    );
  }

  void _parseInput() {
    double x = _nextDouble();
    double y = _nextDouble();
    double r = _nextDouble();
    _stateObjects.add(InputObject(x: x, y: y, flowRate: r, state: false));
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

  ToggleObject? _findToggle() {
    for (int i = _stateObjects.length - 1; i >= 0; --i) {
      if (_stateObjects[i] is ToggleObject) {
        return _stateObjects[i] as ToggleObject;
      }
    }
    return null;
  }

  SockObject? _findSocket(int idx) {
    int loc = (_stateObjects.length) + idx;

    if (loc >= 0 && loc < _stateObjects.length) {
      if (_stateObjects[loc] is SockObject) {
        return _stateObjects[loc] as SockObject;
      }
    }
    return null;
  }

  void _parseState() {
    Token a1 = _nextToken();

    if (a1.isNumber) {
      ToggleObject? obj = _findToggle();
      if (obj != null) {
        obj.toggle = _number(a1.index) != 0;
      }
    } else if (a1.isIdentifier) {
      ToggleObject? obj = _findToggle();
      if (obj != null) {
        var val = _string(a1.index);
        obj.toggle = val == "yes" || val == "open";
      }
    }
  }

  void _parseLink() {
    // enforce the limit if it is not found
    var max = _stateObjects.length;

    var offsA = _nextInteger(def: max);
    var offsB = _nextInteger(def: max);

    SockObject? a = _findSocket(offsA);
    SockObject? b = _findSocket(offsB);

    if (b != null && a != null) {
      b.addInput(a);
    }
  }
}
