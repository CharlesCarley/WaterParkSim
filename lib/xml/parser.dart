import 'package:waterpark/util/stack.dart';
import 'package:waterpark/xml/node.dart';
import 'package:waterpark/xml/scanner.dart';
import 'package:waterpark/xml/token.dart';

abstract class XmlParseLogger {
  void log(String message);
}

class XmlStubParseLogger with XmlParseLogger {
  @override
  void log(String message) {}
}

class XmlParser {
  late XmlScanner _scanner;
  late int _cursor;
  late List<XmlToken> _tokens;
  final List<String> _tags;
  final Stack<XmlNode> _stack = Stack.zero();
  final XmlParseLogger _logger;
  late XmlNode _root;

  bool get hasRoot => _root.children.isNotEmpty;
  XmlNode get root => _root.children.first;

  /// Constructs an xml parser with a list of tag names and an optional
  /// error logger callback.
  ///
  /// Actual tag names are stored in the [XmlNode.name] as the integer index
  /// into the supplied tag list. A [XmlNode.name] of -1 means that the tag is
  /// unnamed.
  XmlParser(this._tags, {XmlParseLogger? logger})
      : _logger = _getLogger(logger);

  /// Utility construction method to guarantee a valid [XmlParseLogger] instance.
  static XmlParseLogger _getLogger(XmlParseLogger? logger) {
    if (logger != null) {
      return logger;
    }
    return XmlStubParseLogger();
  }

  /// Provides access to the token at the supplied offset from the curser
  /// position. If the offset is greater than the number of tokens read, a new
  /// token will be scanned and added to the internal list of tokens.
  XmlToken _getToken(int offset) {
    int pos = _cursor + offset;
    while (pos + 1 > _tokens.length) {
      XmlToken tok = _scanner.scan();
      _tokens.add(tok);
    }
    return _tokens[pos];
  }

  /// Moves the cursor position forward by [n] steps.
  void _advanceCursor(int n) {
    _cursor += n;
  }

  /// Interprets the supplied buffer as XML and attempts to construct an XML
  /// parse tree using [XmlNode].
  void parse(String buffer) {
    _tokens = [];
    _cursor = 0;
    _stack.clear();
    _root = XmlNode(-1);
    _stack.push(_root);
    _scanner = XmlScanner.fromString(buffer, _logger);

    bool rd = true;
    do {
      XmlToken tok = _getToken(0);
      rd = tok.type != XmlTok.tokEof || tok.type != XmlTok.tokError;
      if (rd) {
        int old = _cursor;
        rd = _parseRuleObjectList();
        if (old == _cursor) {
          _advanceCursor(1);
        }
      }
    } while (rd);
  }

  bool _parseRuleObjectList() {
    XmlToken t0 = _getToken(0);
    XmlToken t1 = _getToken(1);

    if (t0.type == XmlTok.tokStTag && t1.type == XmlTok.tokQuestion) {
      return _ruleXmlRoot();
    } else if (t0.type == XmlTok.tokStTag) {
      return _ruleObject();
    }
    return false;
  }

  bool _ruleXmlRoot() {
    var t0 = _getToken(0).type;
    var t1 = _getToken(1).type;
    var t2 = _getToken(2).index;

    String val = _scanner.tokenValue(t2);

    if (t0 != XmlTok.tokStTag) {
      _logger.log("expected the '<' character");
      return false;
    }
    if (t1 != XmlTok.tokQuestion) {
      _logger.log("expected the '/' character");
      return false;
    }
    if (val != "xml") {
      _logger.log("expected the xml keyword");
      return false;
    }

    _advanceCursor(3);
    t0 = _getToken(0).type;

    while (t0 != XmlTok.tokQuestion) {
      if (!_ruleAttribute()) return false;
      t0 = _getToken(0).type;
      if (t0 == XmlTok.tokEof) {
        _logger.log("unexpected end of file");
        return false;
      }
    }

    _advanceCursor(1);
    t0 = _getToken(0).type;
    if (t0 != XmlTok.tokEnTag) {
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

    if (t0 != XmlTok.tokIdentifier) {
      _logger.log("expected an identifier");
      return false;
    }
    if (t1 != XmlTok.tokEquals) {
      _logger.log("expected an equals sign");

      return false;
    }
    if (t2 != XmlTok.tokString) {
      _logger.log("expected an equals sign");
      return false;
    }

    XmlNode? nodePtr = _stack.top();
    if (nodePtr == null) {
      return false;
    }
    XmlNode node = nodePtr;
    String identifier = _scanner.tokenValue(_getToken(0).index);

    if (node.contains(identifier)) {
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

    if (t0 == XmlTok.tokStTag && t1 == XmlTok.tokIdentifier) {
      return _ruleStartTag();
    }
    if (t0 == XmlTok.tokStTag &&
        t1 == XmlTok.tokSlash &&
        t2 == XmlTok.tokIdentifier) {
      return _ruleEndTag();
    }
    return false;
  }

  bool _ruleStartTag() {
    var t0 = _getToken(0);
    var t1 = _getToken(1);

    if (t0.type != XmlTok.tokStTag) {
      _logger.log("expected the < character");
      return false;
    }

    if (t1.type != XmlTok.tokIdentifier) {
      _logger.log("expected a tag identifier");
      return false;
    }

    var value = _scanner.tokenValue(t1.index);
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
    if (et0 == XmlTok.tokSlash) {
      if (_getToken(1).type != XmlTok.tokEnTag) {
        _logger.log("expected the '>' character ");
        return false;
      }

      _reduceRule();
      _advanceCursor(2);
    } else if (et0 != XmlTok.tokEnTag) {
      _logger.log("expected the '>' character ");
      return false;
    } else {
      _advanceCursor(1);
    }

    return true;
  }

  bool _ruleEndTag() {
    var t0 = _getToken(0).type;
    var t1 = _getToken(1).type;
    var t2 = _getToken(2).type;
    var t3 = _getToken(3).type;

    if (t0 != XmlTok.tokStTag) {
      _logger.log("expected the '<' character");
      return false;
    }

    if (t1 != XmlTok.tokSlash) {
      _logger.log("expected the '/' character");
      return false;
    }

    if (t2 != XmlTok.tokIdentifier) {
      _logger.log("expected a tag identifier");
      return false;
    }
    if (t3 != XmlTok.tokEnTag) {
      _logger.log("expected the '>' character");
      return false;
    }

    var identifier = _scanner.tokenValue(_getToken(2).index);
    var top = _stack.top();
    if (top == null) {
      _logger.log("Too many nodes were removed from the stack");
      return false;
    }

    if (top.name >= 0 && identifier != _tags[top.name]) {
      _logger.log("closing tag mis-match between "
          "'${_tags[top.name]}' and '$identifier'");
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
    // indexOf returns -1 if not found
    _stack.push(XmlNode(_tags.indexOf(value)));
  }

  void _reduceRule() {
    if (_stack.isNotEmpty) {
      XmlNode? b = _stack.top();
      _stack.pop();

      XmlNode? a = _stack.top();
      if (a != null && b != null) {
        a.addChild(b);
      } else {
        _logger.log("failed to reduce rule");
      }
    }
  }

  bool _ruleAttributeList() {
    var t0 = _getToken(0).type;
    if (t0 != XmlTok.tokEnTag && t0 != XmlTok.tokSlash) {
      do {
        if (!_ruleAttribute()) {
          return false;
        }

        t0 = _getToken(0).type;
        if (t0 == XmlTok.tokEof) {
          _logger.log("unexpected end of file");
          return false;
        }
      } while (t0 != XmlTok.tokEnTag && t0 != XmlTok.tokSlash);
    }
    return true;
  }
}
