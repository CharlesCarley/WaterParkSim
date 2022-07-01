import 'package:waterpark_frontend/state/input_state.dart';
import 'package:waterpark_frontend/state/common_state.dart';
import 'package:waterpark_frontend/state/tank_state.dart';
import 'package:waterpark_frontend/state/toggle_state.dart';

import '../state/socket_state.dart';
import 'tokenizer.dart';

class StateTreeCompiler {
  final Tokenizer _tokenizer = Tokenizer();

  List<Node> compile(String buffer) {
    _position = 0;
    _tokens = _tokenizer.tokenize(buffer);
    _stateObjects = [];

    bool running = true;
    do {
      Token it = nextToken();
      if (it.isKeyword()) {
        readKeyword(it);
      } else {
        running = false;
      }
    } while (running);

    return _stateObjects;
  }

  void readKeyword(Token current) {
    String kw = _tokenizer.getKeyword(current.index);
    if (kw.isEmpty) return;

    if (kw == "tank") {
      parseTank();
    } else if (kw == "sock") {
      parseSock();
    } else if (kw == "input") {
      parseInput();
    } else if (kw == "state") {
      parseState();
    } else if (kw == "link") {
      parseLink();
    }
  }

  List<Token> _tokens = [];
  int _position = 0;
  List<Node> _stateObjects = [];

  bool endOfStream() {
    return _position >= _tokens.length;
  }

  Token peekToken(int offset) {
    int loc = _position + offset;
    if (loc < 0 || loc >= _tokens.length) {
      return Token.fromId(TokenId.none);
    }
    return _tokens[loc];
  }

  Token nextToken() {
    int loc = _position;
    if (loc < 0 || loc >= _tokens.length) {
      return Token.fromId(TokenId.none);
    }
    ++_position;
    return _tokens[loc];
  }

  void advance(int offset) {
    _position += offset;
  }

  void readEnd() {
    _position = _tokens.length + 1;
  }

  double number(int idx, {double def = 0.0}) {
    return _tokenizer.getNumber(idx, def: def);
  }

  int integer(int idx, {int def = 0}) {
    return _tokenizer.getNumber(idx, def: def.toDouble()).toInt();
  }

  String string(int idx, {String def = ""}) {
    return _tokenizer.getIdentifier(idx, def: def);
  }

  String keyword(int idx, {String def = ""}) {
    return _tokenizer.getKeyword(idx, def: def);
  }

  double nextDouble({double def = 0}) {
    Token a1 = nextToken();
    if (a1.isNumber()) return number(a1.index, def: def);
    return def;
  }

  int nextInteger({int def = 0}) {
    return nextDouble(def: def.toDouble()).toInt();
  }

  String nextString({String def = ""}) {
    Token a1 = nextToken();
    if (a1.isIdentifier()) return string(a1.index, def: def);
    if (a1.isKeyword()) return keyword(a1.index, def: def);
    return def;
  }

  void parseSock() {
    String a1 = nextString();
    double a2 = nextDouble();
    double a3 = nextDouble();

    int dir = parseDirection(a1);

    int signX = (dir & SocketBits.E) != 0 ? -1 : 1;
    int signY = (dir & SocketBits.S) != 0 ? -1 : 1;

    _stateObjects.add(SockObject(
      dir: dir,
      dx: signX * a2,
      dy: signY * a3,
    ));
  }

  void parseTank() {
    double x = nextDouble();
    double y = nextDouble();
    double h = nextDouble();
    double c = nextDouble();
    double d = nextDouble();
    _stateObjects.add(
      TankObject(x: x, y: y, height: h, capacity: c, level: d),
    );
  }

  void parseInput() {
    double x = nextDouble();
    double y = nextDouble();
    double r = nextDouble();
    _stateObjects.add(InputObject(x: x, y: y, flowRate: r, state: false));
  }

  int parseDirection(String string) {
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
    return dir;
  }

  ToggleObject? findToggle() {
    for (int i = _stateObjects.length - 1; i >= 0; --i) {
      if (_stateObjects[i] is ToggleObject) {
        return _stateObjects[i] as ToggleObject;
      }
    }
    return null;
  }

  SockObject? findSocket(int idx) {
    int loc = (_stateObjects.length) + idx;

    if (loc >= 0 && loc < _stateObjects.length) {
      if (_stateObjects[loc] is SockObject) {
        return _stateObjects[loc] as SockObject;
      }
    }

    return null;
  }

  void parseState() {
    Token a1 = nextToken();

    if (a1.isNumber()) {
      ToggleObject? obj = findToggle();
      if (obj != null) {
        obj.toggle = number(a1.index) != 0;
      }
    } else if (a1.isIdentifier()) {
      ToggleObject? obj = findToggle();
      if (obj != null) {
        var val = string(a1.index);
        obj.toggle = val == "yes" || val == "open";
      }
    }
  }

  void parseLink() {
    int offsA = nextInteger(def: _stateObjects.length + 1);
    int offsB = nextInteger(def: _stateObjects.length + 1);

    SockObject? a = findSocket(offsA);
    SockObject? b = findSocket(offsB);

    if (b != null && a != null) {
      a.addInput(b);
    }
  }
}
