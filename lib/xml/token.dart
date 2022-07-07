enum XmlTok {
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
  final XmlTok type;
  final int index;

  XmlToken({
    XmlTok tokenType = XmlTok.tokEof,
    int idx = -1,
  })  : type = tokenType,
        index = idx;
}
