import 'package:waterpark/util/stack.dart';
import 'package:waterpark/xml/node.dart';
import 'package:waterpark/xml/scanner.dart';
import 'package:waterpark/xml/token.dart';

class XmlParseLogger {
  XmlParseLogger();
  void log(String message) {}
}

class XmlParser {
  XmlNode root = XmlNode(-1);
  late XmlScanner _scanner;
  late int _cursor;
  late List<XmlToken> _tokens;
  final List<String> _tags;
  final Stack<XmlNode> _stack = Stack.zero();

  final XmlParseLogger _logger;

  XmlParser(this._tags, {XmlParseLogger? logger})
      : _logger = _getLogger(logger);

  XmlToken _getToken(int offset) {
    int pos = _cursor + offset;
    while (pos + 1 > _tokens.length) {
      XmlToken tok = _scanner.scan();
      _tokens.add(tok);
    }
    return _tokens[pos];
  }

  void _advanceCursor(int n) {
    _cursor += n;
  }

  static XmlParseLogger _getLogger(XmlParseLogger? logger) {
    if (logger != null) {
      return logger;
    }
    return XmlParseLogger();
  }

  void parse(String buffer) {
    _tokens = [];
    _cursor = 0;
    _stack.clear();
    _stack.push(root);
    _scanner = XmlScanner.fromString(buffer);

    bool keepGoing = true;
    do {
      XmlToken tok = _getToken(0);
      if (tok.type == XmlTokenType.tokEof) {
        keepGoing = false;
      } else if (tok.type == XmlTokenType.tokError) {
        keepGoing = false;
      } else {
        int old = _cursor;
        keepGoing = _parseRuleObjectList();
        if (old == _cursor) {
          _advanceCursor(1);
        }
      }
    } while (keepGoing);
  }

  bool _parseRuleObjectList() {
    XmlToken t0 = _getToken(0);
    XmlToken t1 = _getToken(1);

    if (t0.type == XmlTokenType.tokStTag &&
        t1.type == XmlTokenType.tokQuestion) {
      return _ruleXmlRoot();
    } else if (t0.type == XmlTokenType.tokStTag) {
      return _ruleObject();
    }

    return false;
  }

  bool _ruleXmlRoot() {
    var t0 = _getToken(0).type;
    var t1 = _getToken(1).type;
    var t2 = _getToken(2).index;

    String val = _scanner.tokenValue(t2);

    if (t0 != XmlTokenType.tokStTag) {
      _logger.log("expected the '<' character");
      return false;
    }
    if (t1 != XmlTokenType.tokQuestion) {
      _logger.log("expected the '/' character");
      return false;
    }
    if (val != "xml") {
      _logger.log("expected the xml keyword");
      return false;
    }

    _advanceCursor(3);
    t0 = _getToken(0).type;

    while (t0 != XmlTokenType.tokQuestion) {
      if (!_ruleAttribute()) return false;
      t0 = _getToken(0).type;
      if (t0 == XmlTokenType.tokEof) {
        _logger.log("unexpected end of file");
        return false;
      }
    }

    _advanceCursor(1);
    t0 = _getToken(0).type;
    if (t0 != XmlTokenType.tokEnTag) {
      _logger.log("unexpected token $t0");
      return false;
    }
    _advanceCursor(1);
    return true;
  }

  bool _ruleAttribute() {
    var t0 = _getToken(0).type;
    var t1 = _getToken(1).type;
    var t2 = _getToken(2).type;

    if (t0 != XmlTokenType.tokIdentifier) {
      _logger.log("expected an identifier");
      return false;
    }
    if (t1 != XmlTokenType.tokEquals) {
      _logger.log("expected an equals sign");

      return false;
    }
    if (t2 != XmlTokenType.tokString) {
      _logger.log("expected an equals sign");
      return false;
    }

    XmlNode? nodePtr = _stack.top();
    if (nodePtr == null) {
      return false;
    }
    XmlNode node = nodePtr;
    String identifier = _scanner.tokenValue(_getToken(0).index);

    if (node.hasAttribute(identifier)) {
      _logger.log("node ${node.name} duplicate attribute $identifier");
      return false;
    }

    String value = _scanner.tokenValue(_getToken(2).index);

    node.addAttribute(identifier, value);
    _advanceCursor(3);
    return true;
  }

  bool _ruleObject() {
    var t0 = _getToken(0).type;
    var t1 = _getToken(1).type;
    var t2 = _getToken(2).type;

    if (t0 == XmlTokenType.tokStTag && t1 == XmlTokenType.tokIdentifier) {
      return _ruleStartTag();
    }
    if (t0 == XmlTokenType.tokStTag &&
        t1 == XmlTokenType.tokSlash &&
        t2 == XmlTokenType.tokIdentifier) {
      return _ruleEndTag();
    }
    return false;
  }

  bool _ruleStartTag() {
    var t0 = _getToken(0);
    var t1 = _getToken(1);

    if (t0.type != XmlTokenType.tokStTag) {
      _logger.log("expected the < character");
      return false;
    }

    if (t1.type != XmlTokenType.tokIdentifier) {
      _logger.log("expected a tag identifier");
      return false;
    }

    String value = _scanner.tokenValue(t1.index);

    if (value.isEmpty) {
      _logger.log("empty tag name");
      return false;
    }

    _advanceCursor(2);
    _createTag(value);

    if (!_ruleAttributeList()) {
      return false;
    }

    // Test exit state from the attribute list call
    // > means leave node on the stack
    // / means remove the node from the stack

    var et0 = _getToken(0).type;
    var result = true;
    if (et0 == XmlTokenType.tokSlash) {
      var et1 = _getToken(1).type;
      if (et1 != XmlTokenType.tokEnTag) {
        _logger.log("expected the '>' character ");
      }

      _reduceRule();
      _advanceCursor(2);
    } else if (et0 != XmlTokenType.tokEnTag) {
      _logger.log("expected the '>' character ");
      result = false;
    } else {
      _advanceCursor(1);
    }
    return result;
  }

  bool _ruleEndTag() {
    // '<' '/'
    var t0 = _getToken(0).type;
    var t1 = _getToken(1).type;
    var t2 = _getToken(2).type;
    var t3 = _getToken(3).type;

    if (t0 != XmlTokenType.tokStTag) {
      _logger.log("expected the '<' character");
      return false;
    }
    if (t1 != XmlTokenType.tokSlash) {
      _logger.log("expected the '/' character");
      return false;
    }
    if (t2 != XmlTokenType.tokIdentifier) {
      _logger.log("expected a tag identifier");
      return false;
    }
    if (t3 != XmlTokenType.tokEnTag) {
      _logger.log("expected the '>' character");
      return false;
    }

    String identifier = _scanner.tokenValue(_getToken(2).index);
    XmlNode? nodePtr = _stack.top();
    if (nodePtr == null) {
      return false;
    }
    if (nodePtr.name >= 0 && identifier != _tags[nodePtr.name]) {
      _logger.log(
          "closing tag mis-match between '${_tags[nodePtr.name]}' and '$identifier'");
      return false;
    }

    if (identifier.isEmpty) {
      _logger.log("empty closing tag");
      return false;
    }
    _advanceCursor(4);
    _reduceRule();
    return true;
  }

  void _createTag(String value) {
    int idx = _tags.indexOf(value);

    // allow -1
    XmlNode node = XmlNode(idx);
    _stack.push(node);
  }

  void _reduceRule() {
    if (_stack.isNotEmpty) {
      XmlNode? b = _stack.top();
      _stack.pop();

      XmlNode? a = _stack.top();

      if (a != null && b != null) {
        a.addChild(b);
      }
    }
  }

  bool _ruleAttributeList() {
    var t0 = _getToken(0).type;

    if (t0 != XmlTokenType.tokEnTag && t0 != XmlTokenType.tokSlash) {
      do {
        if (!_ruleAttribute()) {
          return false;
        }

        t0 = _getToken(0).type;

        if (t0 == XmlTokenType.tokEof) {
          _logger.log("unexpected end of file");
          return false;
        }
      } while (t0 != XmlTokenType.tokEnTag && t0 != XmlTokenType.tokSlash);
    }
    return true;
  }
}
