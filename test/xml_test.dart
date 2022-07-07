// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'package:flutter_test/flutter_test.dart';
import 'package:waterpark/xml/node.dart';
import 'package:waterpark/xml/parser.dart';
import 'package:waterpark/xml/scanner.dart';
import 'package:waterpark/xml/token.dart';

class PrintLogger extends XmlParseLogger {
  @override
  void log(String message) {
    print(message);
  }
}

void main() {
  test("XML_SmokeTest_1", () {
    XmlNode A = XmlNode(-1);
    XmlNode B = XmlNode(-1);

    A.addChild(B);

    expect(A.hasParent, false);
    expect(A.hasChildren, true);
    expect(B.hasParent, true);
    expect(B.hasChildren, false);
    expect(B.parent, A);
  });

  test("XML_SmokeTest_2", () {
    XmlScanner scan = XmlScanner.fromString("""
<?xml version="1.0"?>
    """);

    expect(scan.scan().type, XmlTokenType.tokStTag);
    expect(scan.scan().type, XmlTokenType.tokQuestion);
    expect(scan.scan().type, XmlTokenType.tokIdentifier);
    expect(scan.scan().type, XmlTokenType.tokIdentifier);
    expect(scan.scan().type, XmlTokenType.tokEquals);
    expect(scan.scan().type, XmlTokenType.tokString);
    expect(scan.scan().type, XmlTokenType.tokQuestion);
    expect(scan.scan().type, XmlTokenType.tokEnTag);
  });

  test("XML_SmokeTest_2", () {
    XmlScanner scan = XmlScanner.fromString("""
<page>
  <input>
  <foo/>
  </input>
</page>
    """);

    expectTag(scan, "page", false);
    expectTag(scan, "input", false);
    expectInlineTag(scan, "foo");
    expectTag(scan, "input", true);
    expectTag(scan, "page", true);
  });

  test("XML_SmokeTest_3", () {
    XmlScanner scan = XmlScanner.fromString("""
<page name="Foo">
  <input x="0" y="10" r="5"/>
</page>
    """);
    expectTagAttributes(scan, "page", ["name"], ["Foo"], false, false);
    expectTagAttributes(
        scan, "input", ["x", "y", "r"], ["0", "10", "5"], false, true);
    expectTag(scan, "page", true);
  });
  test("XML_SmokeTest_4", () {
    var tags = ["page", "input"];

    XmlParser parser = XmlParser(tags, logger: PrintLogger());

    parser.parse("""
<page name="Foo">
  <input x="0" y="10" r="5"/>
</page>
    """);


    XmlNode nd = parser.root.children.first;
    print("$nd");

    
  });
}

void expectTag(XmlScanner scan, String name, bool isClose) {
  expect(scan.scan().type, XmlTokenType.tokStTag);
  if (isClose) {
    expect(scan.scan().type, XmlTokenType.tokSlash);
  }

  XmlToken tok = scan.scan();
  expect(tok.type, XmlTokenType.tokIdentifier);
  expect(tok.index != -1, true);

  String value = scan.tokenValue(tok.index);
  expect(value, name);
  expect(scan.scan().type, XmlTokenType.tokEnTag);
}

void expectInlineTag(XmlScanner scan, String name) {
  expect(scan.scan().type, XmlTokenType.tokStTag);

  XmlToken tok = scan.scan();
  expect(tok.type, XmlTokenType.tokIdentifier);
  expect(tok.index != -1, true);

  String value = scan.tokenValue(tok.index);
  expect(value, name);
  expect(scan.scan().type, XmlTokenType.tokSlash);
  expect(scan.scan().type, XmlTokenType.tokEnTag);
}

void expectTagAttributes(
  XmlScanner scan,
  String name,
  List<String> keys,
  List<String> values,
  bool isClose,
  bool isInline,
) {
  expect(keys.length == values.length, true);
  expect(scan.scan().type, XmlTokenType.tokStTag);
  if (isClose) {
    expect(scan.scan().type, XmlTokenType.tokSlash);
  }

  XmlToken tok = scan.scan();
  expect(tok.type, XmlTokenType.tokIdentifier);
  expect(tok.index != -1, true);

  for (int i = 0; i < keys.length; ++i) {
    String key = keys[i];
    String val = values[i];

    tok = scan.scan();
    expect(tok.type, XmlTokenType.tokIdentifier);
    expect(tok.index != -1, true);

    String value = scan.tokenValue(tok.index);
    expect(value, key);

    expect(scan.scan().type, XmlTokenType.tokEquals);
    tok = scan.scan();
    expect(tok.type, XmlTokenType.tokString);
    expect(tok.index != -1, true);

    value = scan.tokenValue(tok.index);
    expect(value, val);
  }
  if (isInline) {
    expect(scan.scan().type, XmlTokenType.tokSlash);
  }
  expect(scan.scan().type, XmlTokenType.tokEnTag);
}
