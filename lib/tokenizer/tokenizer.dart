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

  get isNone => id == TokenId.none;
  get isEos => id == TokenId.eos;
  get isNoneOrEos => isNone || isEos;
  get isNumber => id == TokenId.number;
  get isKeyword => id == TokenId.keyword;
  get isIdentifier => id == TokenId.identifier;
}

final List<String> keyWords = [
  "tank",
  "sock",
  "input",
  "state",
  "link",
];

class Tokenizer {
  List<Token> _tokens = [];
  Uint8List _bytes = Uint8List(0);
  final List<String> _identifiers = [];
  final List<double> _values = [];

  int _position = 0;

  bool _endOfStream() {
    return _position >= _bytes.length;
  }

  void _advance(int offset) {
    _position += offset;
  }

  bool _isNewLineOrWhiteSpace(int ch) {
    return ch == 0x20 || ch == 0x09 || ch == 0x0D || ch == 0x0A;
  }

  bool _isDigit(int ch) {
    return ch >= 0x30 && ch <= 0x39;
  }

  bool _isNumeric(int ch) {
    return ch == 0x2E || ch == 0x2D || _isDigit(ch);
  }

  bool _isAlpha(int ch) {
    return (ch >= 0x61 && ch <= 0x7A) || (ch >= 0x41 && ch <= 0x5A);
  }

  bool _isAlphaNumeric(int ch) {
    return _isAlpha(ch) || _isDigit(ch);
  }

  List<Token> tokenize(String buffer) {
    _bytes = ascii.encode(buffer);
    _tokens = [];
    _position = 0;

    while (!_endOfStream()) {
      var tok = _nextToken();
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

  int _currentByte({int offset = 0}) {
    int loc = _position + offset;
    if (loc < 0 || loc >= _bytes.length) {
      return -1;
    }
    return _bytes[loc];
  }

  Token _nextToken() {
    Token tok = Token.fromId(TokenId.error);
    late bool readMore;
    do {
      readMore = false;
      int ch = _currentByte();
      if (_isAlpha(ch)) {
        _scanId(tok);
      } else if (_isNumeric(ch)) {
        _scanNumber(tok);
      } else if (!_isNewLineOrWhiteSpace(ch)) {
        tok.id = TokenId.error;
      } else {
        _advance(1);
        readMore = true;
      }
    } while (readMore && !_endOfStream());
    return tok;
  }

  void _scanId(Token tok) {
    StringBuffer buffer = StringBuffer();
    var ch = _currentByte();
    while (!_endOfStream() && _isAlphaNumeric(ch)) {
      ch = _currentByte();

      if (_isNewLineOrWhiteSpace(ch)) {
        break;
      }

      if (_isAlphaNumeric(ch)) {
        _advance(1);
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
    var ch = _currentByte();
    while (!_endOfStream() && _isNumeric(ch)) {
      ch = _currentByte();
      if (_isNewLineOrWhiteSpace(ch)) {
        break;
      } else if (_isNumeric(ch)) {
        _advance(1);
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
