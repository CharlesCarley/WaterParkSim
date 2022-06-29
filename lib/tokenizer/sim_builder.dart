import 'package:waterpark_frontend/state/input_object.dart';
import 'package:waterpark_frontend/state/node.dart';
import 'package:waterpark_frontend/state/tank_object.dart';

import '../state/socket_object.dart';
import 'tokenizer.dart';

class SimBuilder {
  final Tokenizer _tokenizer = Tokenizer();
  List<Token> _tokens = [];
  int _position = 0;
  List<Node> _stateObjects = [];

  bool endOfStream() {
    return _position >= _tokens.length;
  }

  Token token(int offset) {
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

  List<Node> parse(String buffer) {
    _position = 0;
    _tokens = _tokenizer.tokenize(buffer);
    _stateObjects = [];

    Token current = token(0);

    while (!current.isEos()) {
      current = token(0);
      if (current.isKeyword()) {
        advance(1);
        readKeyword(current);
      } else {
        break;
      }
    }
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
    }
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

  void parseSock() {
    Token a1 = nextToken();
    Token a2 = nextToken();
    Token a3 = nextToken();

    bool result = a1.isIdentifier();
    result = a2.isNumber() && result;
    result = a3.isNumber() && result;

    if (result) {
      int dir = parseDirection(string(a1.index));
      int signx = (dir & SocketBits.E) != 0 ? -1 : 1;
      int signy = (dir & SocketBits.S) != 0 ? -1 : 1;

      _stateObjects.add(SockObject(
        dir: dir,
        dx: signx * number(a2.index, def: 0),
        dy: signy * number(a3.index, def: 0),
      ));
    }
  }

  void parseTank() {
    Token a1 = nextToken();
    Token a2 = nextToken();
    Token a3 = nextToken();
    Token a4 = nextToken();
    Token a5 = nextToken();

    bool result = a1.isNumber();
    result = a2.isNumber() && result;
    result = a3.isNumber() && result;
    result = a4.isNumber() && result;
    result = a5.isNumber() && result;

    if (result) {
      _stateObjects.add(TankObject(
        x: number(a1.index),
        y: number(a2.index),
        height: number(a3.index),
        capacity: number(a4.index),
        level: number(a5.index),
      ));
    }
  }

  void parseInput() {
    Token a1 = nextToken();
    Token a2 = nextToken();
    Token a3 = nextToken();

    bool result = a1.isNumber();
    result = a2.isNumber() && result;
    result = a3.isNumber() && result;

    if (result) {
      _stateObjects.add(InputObject(
        x: number(a1.index),
        y: number(a2.index),
        flowRate: number(a3.index),
      ));
    }
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
}
