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
import 'package:waterpark/tokenizer/sim_builder.dart';

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

    expect(scan.scan().type, XmlTok.tokStTag);
    expect(scan.scan().type, XmlTok.tokQuestion);
    expect(scan.scan().type, XmlTok.tokIdentifier);
    expect(scan.scan().type, XmlTok.tokIdentifier);
    expect(scan.scan().type, XmlTok.tokEquals);
    expect(scan.scan().type, XmlTok.tokString);
    expect(scan.scan().type, XmlTok.tokQuestion);
    expect(scan.scan().type, XmlTok.tokEnTag);
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

    XmlNode nd = parser.root;

    expect(nd.contains('name'), true);
    expect(nd.asString('name'), "Foo");

    expect(parser.root.hasChildren, true);

    nd = parser.root.children.first;
    expect(nd.contains('x'), true);
    expect(nd.asDouble('x'), 0.0);

    expect(nd.contains('y'), true);
    expect(nd.asDouble('y'), 10.0);

    expect(nd.contains('r'), true);
    expect(nd.asDouble('r'), 5.0);
  });
  test("XML_SmokeTest_5", () {
    XmlParser parser = XmlParser(
      ObjectTags.values.asNameMap().keys.toList(),
      logger: PrintLogger(),
    );

    parser.parse("""
<page>
  <!-- =========================== -->
  <input x="10" 
         y="10" 
         rate="6" 
         state="on">
    <osock id="0" dir="NE" ox="0" oy="0"/>
  </input>
  
  <!-- =========================== -->
  <tank x="10" 
        y="10" 
        height="20" 
        capacity="500"
        level="15">
  
  </tank>
</page>
    """);

    expect(parser.root.hasChildren, true);
    XmlNode nd = parser.root;

    expect(nd.name, ObjectTags.page.index);
    expect(nd.hasChildren, true);

    nd = parser.root.children[0];
    expect(nd.name, ObjectTags.input.index);

    nd = parser.root.children[1];
    expect(nd.name, ObjectTags.tank.index);
  });
}

void expectTag(XmlScanner scan, String name, bool isClose) {
  expect(scan.scan().type, XmlTok.tokStTag);
  if (isClose) {
    expect(scan.scan().type, XmlTok.tokSlash);
  }

  XmlToken tok = scan.scan();
  expect(tok.type, XmlTok.tokIdentifier);
  expect(tok.index != -1, true);

  String value = scan.tokenValue(tok.index);
  expect(value, name);
  expect(scan.scan().type, XmlTok.tokEnTag);
}

void expectInlineTag(XmlScanner scan, String name) {
  expect(scan.scan().type, XmlTok.tokStTag);

  XmlToken tok = scan.scan();
  expect(tok.type, XmlTok.tokIdentifier);
  expect(tok.index != -1, true);

  String value = scan.tokenValue(tok.index);
  expect(value, name);
  expect(scan.scan().type, XmlTok.tokSlash);
  expect(scan.scan().type, XmlTok.tokEnTag);
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
  expect(scan.scan().type, XmlTok.tokStTag);
  if (isClose) {
    expect(scan.scan().type, XmlTok.tokSlash);
  }

  XmlToken tok = scan.scan();
  expect(tok.type, XmlTok.tokIdentifier);
  expect(tok.index != -1, true);

  for (int i = 0; i < keys.length; ++i) {
    String key = keys[i];
    String val = values[i];

    tok = scan.scan();
    expect(tok.type, XmlTok.tokIdentifier);
    expect(tok.index != -1, true);

    String value = scan.tokenValue(tok.index);
    expect(value, key);

    expect(scan.scan().type, XmlTok.tokEquals);
    tok = scan.scan();
    expect(tok.type, XmlTok.tokString);
    expect(tok.index != -1, true);

    value = scan.tokenValue(tok.index);
    expect(value, val);
  }
  if (isInline) {
    expect(scan.scan().type, XmlTok.tokSlash);
  }
  expect(scan.scan().type, XmlTok.tokEnTag);
}
