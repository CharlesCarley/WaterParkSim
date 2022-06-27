import 'dart:convert';
import 'dart:typed_data';
import 'package:waterpark_frontend/state/node.dart';
import 'package:waterpark_frontend/state/tank.dart';

enum TokenId {
  none,
  error,
  keyword,
  number,
  identifier,
  eos,
}

class Token {
  TokenId id = TokenId.none;
  int index = -1;
  Token();
  Token.fromId(this.id);

  bool isEos() => id == TokenId.eos;
  bool isNumber() => id == TokenId.number;
  bool isKeyword() => id == TokenId.keyword;
  bool isIdentifier() => id == TokenId.identifier;
}

class Tokenizer {
  List<Token> _tokens = [];
  final List<String> _keywords = ["tank"];
  Uint8List _bytes = Uint8List(0);
  final List<String> _identifiers = [];
  final List<double> _values = [];

  int _position = 0;

  List<Token> tokenize(String buffer) {
    _bytes = ascii.encode(buffer);
    _tokens = [];
    _position = 0;

    while (!endOfStream()) {
      var tok = advanceToken();
      if (tok.id == TokenId.keyword ||
          tok.id == TokenId.number ||
          tok.id == TokenId.identifier) {
        _tokens.add(tok);
      } else {
        break;
      }
    }

    _tokens.add(Token.fromId(TokenId.eos));
    return _tokens;
  }

  bool endOfStream() {
    return _position >= _bytes.length;
  }

  int current({int offset = 0}) {
    int loc = _position + offset;

    if (loc < 0 || loc >= _bytes.length) {
      return -1;
    }

    return _bytes[loc];
  }

  void advance(int offset) {
    _position += offset;
  }

  Token advanceToken() {
    Token tok = Token.fromId(TokenId.error);

    while (!endOfStream()) {
      int ch = current();

      if (isAlpha(ch)) {
        // ascii
        scanIdentifier(tok);
        break;
      } else if (isNumeric(ch)) {
        // digit
        scanNumber(tok);
        break;
      } else if (!isNewLineOrWhiteSpace(ch)) {
        tok.id = TokenId.error;
        break;
      } else {
        advance(1);
      }
    }

    return tok;
  }

  bool isNewLineOrWhiteSpace(int ch) {
    return (ch == 0x20 || ch == 0x09 || ch == 0x0D || ch == 0x0A);
  }

  bool isDigit(int ch) {
    return (ch >= 0x30 && ch <= 0x39);
  }

  bool isNumeric(int ch) {
    return (ch == 0x2E) || (ch == 0x2D) || isDigit(ch);
  }

  bool isAlpha(int ch) {
    return (ch >= 0x61 && ch <= 0x7A) || (ch >= 0x41 && ch <= 0x5A);
  }

  bool isAlphaNumeric(int ch) {
    return isAlpha(ch) || isDigit(ch);
  }

  void scanIdentifier(Token tok) {
    StringBuffer buffer = StringBuffer();
    var ch = current();
    while (!endOfStream() && isAlphaNumeric(ch)) {
      ch = current();
      if (isNewLineOrWhiteSpace(ch)) {
        break;
      }
      if (isAlphaNumeric(ch)) {
        advance(1);
        buffer.writeCharCode(ch);
      } else {
        break;
      }
    }

    if (buffer.isEmpty) {
      tok.id = TokenId.error;
    } else {
      String result = buffer.toString();

      int index = -1;
      for (int i = 0; i < _keywords.length && index == -1; ++i) {
        var str = _keywords[i];
        if (str == result) {
          index = i;
        }
      }

      if (index != -1) {
        tok.id = TokenId.keyword;
        tok.index = index;
      } else {
        tok.id = TokenId.identifier;

        tok.index = _identifiers.indexOf(result);
        if (tok.index == -1) {
          tok.index = _identifiers.length;
          _identifiers.add(result);
        }
      }
    }
  }

  void scanNumber(Token tok) {
    StringBuffer buffer = StringBuffer();
    var ch = current();
    while (!endOfStream() && isNumeric(ch)) {
      ch = current();
      if (isNewLineOrWhiteSpace(ch)) {
        break;
      } else if (isNumeric(ch)) {
        advance(1);
        buffer.writeCharCode(ch);
      } else {
        break;
      }
    }

    if (buffer.isEmpty) {
      tok.id = TokenId.error;
    } else {
      String result = buffer.toString();
      double? v = double.tryParse(result);

      tok.id = TokenId.error;
      if (v != null) {
        tok.id = TokenId.number;
        tok.index = _values.indexOf(v);
        if (tok.index == -1) {
          tok.index = _values.length;
          _values.add(v);
        }
      }
    }
  }

  String getKeyword(int index) {
    if (index >= 0 && index < _keywords.length) {
      return _keywords[index];
    }
    return "";
  }

  String getIdentifier(int index, {String def = ""}) {
    if (index >= 0 && index < _identifiers.length) {
      return _identifiers[index];
    }
    return def;
  }

  double getNumber(int index, {double def = 0.0}) {
    if (index >= 0 && index < _values.length) {
      return _values[index];
    }
    return def;
  }
}

class CommandParser {
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
      return Token.fromId(TokenId.eos);
    }
    return _tokens[loc];
  }

  void advance(int offset) {
    _position += offset;
  }

  void readEnd() {
    _position = _tokens.length+1;
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
      Token a1 = token(0);
      Token a2 = token(1);
      Token a3 = token(2);
      Token a4 = token(3);
      Token a5 = token(4);

      bool result = a1.isNumber();
      result = a2.isNumber() && result;
      result = a3.isNumber() && result;
      result = a4.isNumber() && result;
      result = a5.isNumber() && result;

      if (result) {
        advance(5);
        _stateObjects.add(Tank(
          x: _tokenizer.getNumber(a1.index),
          y: _tokenizer.getNumber(a2.index),
          height: _tokenizer.getNumber(a3.index),
          capacity: _tokenizer.getNumber(a4.index),
          level: _tokenizer.getNumber(a5.index),
        ));
      } else {
        readEnd();
      }
    }
  }
}
