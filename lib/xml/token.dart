enum XmlTokenType {
  tokError,
  tokEof,
  tokIdentifier,
  tokString,
  tokText,
  tokEquals,
  tokStTag,
  tokEnTag,
  tokSlash,
  tokQuestion,
  tokKwXml,
}

class XmlToken {
  final XmlTokenType type;
  final int index;

  XmlToken({
    XmlTokenType tokenType = XmlTokenType.tokEof,
    int idx = -1,
  })  : type = tokenType,
        index = idx;
}
