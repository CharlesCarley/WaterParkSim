import 'dart:convert';
import 'dart:typed_data';

import 'package:waterpark/xml/token.dart';

import 'parser.dart';

class XmlScanner {
  late final Uint8List _buffer;
  late int _position;
  final XmlParseLogger _logger;

  final List<String> _stringCache = [];

  XmlScanner()
      : _buffer = Uint8List(0),
        _position = 0,
        _logger = XmlStubParseLogger();

  XmlScanner.fromString(String buffer, XmlParseLogger logger)
      : _buffer = ascii.encode(buffer),
        _position = 0,
        _logger = logger;

  bool _notEndOfStream() {
    return _position < _buffer.length;
  }

  void _advance(int offset) {
    _position += offset;
  }

  int _current() {
    if (_position < _buffer.length) {
      return _buffer[_position];
    }
    return -1;
  }

  int _peek() {
    var next = _position + 1;
    if (next < _buffer.length) {
      return _buffer[next];
    }
    return -1;
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
    return _isAlpha(ch) || _isNumeric(ch);
  }

  XmlToken scan() {
    while (_notEndOfStream()) {
      int ch = _current();

      switch (ch) {
        case 0x3D: // =
          _advance(1);
          return XmlToken(tokenType: XmlTok.tokEquals);
        case 0x3E: // >
          _advance(1);
          return XmlToken(tokenType: XmlTok.tokEnTag);
        case 0x2F: // =
          _advance(1);
          return XmlToken(tokenType: XmlTok.tokSlash);
        case 0x3F: // =
          _advance(1);
          return XmlToken(tokenType: XmlTok.tokQuestion);
        case 0x3C: // <
          {
            if (_peek() == 0x21) // !
            {
              _skipComment();
            } else {
              _advance(1);
              return XmlToken(tokenType: XmlTok.tokStTag);
            }
          }
          break;
        case 0x22: // "
          _advance(1);
          return _scanString();
        case 0x0A: // \n
        case 0x0D: // \r
          _skipNewLine();
          break;
        case 0x20: // ' '
        case 0x09: // \t
          _skipWhiteSpace();
          break;
        default:
          {
            if (_isAlphaNumeric(ch)) {
              return _scanSymbol();
            } else {
              _advance(1);
              return XmlToken(tokenType: XmlTok.tokError);
            }
          }
      }
    }
    return XmlToken();
  }

  void _skipCode(int A, int B) {
    int ch = _current();
    while (ch == A || ch == B) {
      _advance(1);
      ch = _current();
    }
  }

  void _skipComment() {
    _advance(2);
    int ch = _current();
    while (_notEndOfStream() && ch != 0x3E) {
      _advance(1);
      ch = _current();
    }
    _advance(1);
  }

  void _skipNewLine() {
    _skipCode(0x0A, 0x0D);
  }

  void _skipWhiteSpace() {
    _skipCode(0x20, 0x09);
  }

  int _saveString(String str) {
    if (str.isNotEmpty) {
      int idx = _stringCache.indexOf(str);
      if (idx == -1) {
        idx = _stringCache.isEmpty ? 0 : _stringCache.length;
        _stringCache.add(str);
      }
      return idx;
    }
    return -1;
  }

  XmlToken _scanSymbol() {
    int ch = _current();

    if (_isAlpha(ch)) {
      StringBuffer buf = StringBuffer();
      while (_notEndOfStream() && _isAlphaNumeric(ch)) {
        buf.writeCharCode(ch);
        _advance(1);
        ch = _current();

        // just to keep some sane limit
        if (buf.length > 16) {
          _logger.log("maximum symbol length of 16 exceeded");
          return XmlToken(tokenType: XmlTok.tokError);
        }
      }

      int idx = _saveString(buf.toString());
      if (idx != -1) {
        return XmlToken(
          tokenType: XmlTok.tokIdentifier,
          idx: idx,
        );
      }
    }

    return XmlToken(tokenType: XmlTok.tokError);
  }

  XmlToken _scanString() {
    StringBuffer buf = StringBuffer();

    int ch = _current();
    while (_notEndOfStream() && ch != 0x22) {
      buf.writeCharCode(ch);
      _advance(1);
      ch = _current();

      // just to keep some sane limit
      if (buf.length > 64) {
        _logger.log("maximum string length of 64 exceeded");
        return XmlToken(tokenType: XmlTok.tokError);
      }
    }
    // skip '"' or move beyond end of stream
    _advance(1);

    int idx = _saveString(buf.toString());
    if (idx != -1) {
      return XmlToken(
        tokenType: XmlTok.tokString,
        idx: idx,
      );
    }

    return XmlToken(tokenType: XmlTok.tokError);
  }

  String tokenValue(int idx, {String def = ""}) {
    if (idx < _stringCache.length) {
      return _stringCache[idx];
    }
    return def;
  }
}
