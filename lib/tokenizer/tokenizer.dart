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

  bool isEos() => id == TokenId.eos;
  bool isNumber() => id == TokenId.number;
  bool isKeyword() => id == TokenId.keyword;
  bool isIdentifier() => id == TokenId.identifier;
}

class Tokenizer {
  List<Token> _tokens = [];
  List<String> _keywords = ["tank"];
  Uint8List _bytes = Uint8List(0);
  List<String> identifiers = [];

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

  int current(int offset) {
    int loc = _position + offset;

    if (loc < 0 || loc >= _tokens.length) {
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
      int ch = current(0);

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
    return isDigit(ch) || (ch == 0x2E) || (ch == 0x2D);
  }

  bool isAlpha(int ch) {
    return (ch >= 0x61 && ch <= 0x7A) || (ch >= 0x41 && ch <= 0x5A);
  }

  bool isAlphaNumeric(int ch) {
    return isAlpha(ch) || isDigit(ch);
  }

  void scanIdentifier(Token tok) {
    int offs = 0;

    StringBuffer buffer = StringBuffer();
    int ch = current(0);
    while (!endOfStream() && isAlphaNumeric(ch)) {
      ch = current(offs++);
      if (isNewLineOrWhiteSpace(ch)) {
        break;
      }
      buffer.writeCharCode(ch);
    }

    if (buffer.isEmpty) {
      tok.id = TokenId.error;
    } else {
      String result = buffer.toString();
      advance(offs);

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
        tok.index = identifiers.length;
        identifiers.add(result);
      }
    }
  }

  void scanNumber(Token tok) {}

  String getKeyword(int index) {
    if (index >= 0 && index < _keywords.length) return _keywords[index];
    return "";
  }

  String getIdentifier(int index) {
    if (index >= 0 && index < identifiers.length) return identifiers[index];
    return "";
  }

  double getNumber(int index, {double def = 0.0}) {
    if (index >= 0 && index < identifiers.length) {
      var str = identifiers[index];

      double? v = double.tryParse(str);
      if (v != null) {
        return v;
      }
    }
    return 0.0;
  }
}

class CommandParser {
  Tokenizer _tokenizer = Tokenizer();
  List<Token> _tokens = [];

  int _position = 0;

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

  void advance(int offset) {
    _position += offset;
  }

  void readEnd() {
    _position = _tokens.length;
  }

  void parse(String buffer) {
    _position = 0;
    _tokens = _tokenizer.tokenize(buffer);

    Token current = token(0);

    while (!current.isEos()) {
      if (current.isKeyword()) {
        advance(1);
        readKeyword(current);
      } else {
        break;
      }
    }
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
      } else {
        readEnd();
      }
    }
  }
}
