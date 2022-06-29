import 'dart:convert';
import 'dart:typed_data';

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

  bool isNone() => id == TokenId.none;
  bool isEos() => id == TokenId.eos;
  bool isNoneOrEos() => isNone() || isEos();
  bool isNumber() => id == TokenId.number;
  bool isKeyword() => id == TokenId.keyword;
  bool isIdentifier() => id == TokenId.identifier;
}

final List<String> keyWords = [
  "tank",
  "sock",
  "input",
  "state",
  "line",
];

class Tokenizer {
  List<Token> _tokens = [];
  Uint8List _bytes = Uint8List(0);
  final List<String> _identifiers = [];
  final List<double> _values = [];

  int _position = 0;

  bool endOfStream() {
    return _position >= _bytes.length;
  }

  void advance(int offset) {
    _position += offset;
  }

  bool isNewLineOrWhiteSpace(int ch) {
    return ch == 0x20 || ch == 0x09 || ch == 0x0D || ch == 0x0A;
  }

  bool isDigit(int ch) {
    return ch >= 0x30 && ch <= 0x39;
  }

  bool isNumeric(int ch) {
    return ch == 0x2E || ch == 0x2D || isDigit(ch);
  }

  bool isAlpha(int ch) {
    return (ch >= 0x61 && ch <= 0x7A) || (ch >= 0x41 && ch <= 0x5A);
  }

  bool isAlphaNumeric(int ch) {
    return isAlpha(ch) || isDigit(ch);
  }

  List<Token> tokenize(String buffer) {
    _bytes = ascii.encode(buffer);
    _tokens = [];
    _position = 0;

    while (!endOfStream()) {
      var tok = nextToken();
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

  int currentByte({int offset = 0}) {
    int loc = _position + offset;
    if (loc < 0 || loc >= _bytes.length) {
      return -1;
    }
    return _bytes[loc];
  }

  Token nextToken() {
    Token tok = Token.fromId(TokenId.error);

    while (!endOfStream()) {
      int ch = currentByte();

      if (isAlpha(ch)) {
        // ascii
        _scanId(tok);
        break;
      } else if (isNumeric(ch)) {
        // digit
        _scanNumber(tok);
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

  void _scanId(Token tok) {
    StringBuffer buffer = StringBuffer();
    var ch = currentByte();
    while (!endOfStream() && isAlphaNumeric(ch)) {
      ch = currentByte();

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
    _processId(tok, buffer);
  }

  void _processId(Token tok, StringBuffer buffer) {
    if (buffer.isEmpty) {
      tok.id = TokenId.error;
      return;
    }

    String result = buffer.toString();
    int index = -1;
    for (int i = 0; i < keyWords.length && index == -1; ++i) {
      var str = keyWords[i];
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

  void _scanNumber(Token tok) {
    StringBuffer buffer = StringBuffer();
    var ch = currentByte();
    while (!endOfStream() && isNumeric(ch)) {
      ch = currentByte();
      if (isNewLineOrWhiteSpace(ch)) {
        break;
      } else if (isNumeric(ch)) {
        advance(1);
        buffer.writeCharCode(ch);
      } else {
        break;
      }
    }
    _processNumber(tok, buffer);
  }

  void _processNumber(Token tok, StringBuffer buffer) {
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

  String getKeyword(int index, {String def = ""}) {
    if (index >= 0 && index < keyWords.length) {
      return keyWords[index];
    }
    return def;
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
