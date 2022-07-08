// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'package:flutter_test/flutter_test.dart';
import 'package:waterpark/tokenizer/tokenizer.dart';

void main() {
  /////////////////////////////////////////////////////////////////
  /// Token Tests
  /////////////////////////////////////////////////////////////////
  test("Tokenizer_1", () {
    var tokenizer = Tokenizer();
    var ret = tokenizer.tokenize("-1  a  b  c");
    genericTokenTest(
      ret,
      5,
      [
        TokenId.number,
        TokenId.identifier,
        TokenId.identifier,
        TokenId.identifier,
        TokenId.eos,
      ],
      [0, 0, 1, 2, -1],
    );
    expect(tokenizer.getNumber(ret[0].index), -1.0);
    expect(tokenizer.getIdentifier(ret[1].index), "a");
    expect(tokenizer.getIdentifier(ret[2].index), "b");
    expect(tokenizer.getIdentifier(ret[3].index), "c");
  });

  test("Tokenizer_2", () {
    var tokenizer = Tokenizer();
    var ret = tokenizer.tokenize("sock 4 5 6");
    genericTokenTest(
      ret,
      5,
      [
        TokenId.keyword,
        TokenId.number,
        TokenId.number,
        TokenId.number,
        TokenId.eos,
      ],
      [1, 0, 1, 2, -1],
    );

    expect(tokenizer.getKeyword(ret[0].index), "sock");
    expect(tokenizer.getNumber(ret[1].index), 4);
    expect(tokenizer.getNumber(ret[2].index), 5);
    expect(tokenizer.getNumber(ret[3].index), 6);
  });

  test("Tokenizer_3", () {
    var tokenizer = Tokenizer();

    var ret = tokenizer.tokenize("sock SE 0 20");
    genericTokenTest(
      ret,
      5,
      [
        TokenId.keyword,
        TokenId.identifier,
        TokenId.number,
        TokenId.number,
        TokenId.eos,
      ],
      [1, 0, 0, 1, -1],
    );
    expect(tokenizer.getKeyword(ret[0].index), "sock");
    expect(tokenizer.getIdentifier(ret[1].index), "SE");
    expect(tokenizer.getNumber(ret[2].index), 0);
    expect(tokenizer.getNumber(ret[3].index), 20);
  });

  test("Tokenizer_4", () {
    var tokenizer = Tokenizer();
    var ret = tokenizer.tokenize("tank 20 20 20 15 20.1");
    genericTokenTest(
      ret,
      7,
      [
        TokenId.keyword,
        TokenId.number,
        TokenId.number,
        TokenId.number,
        TokenId.number,
        TokenId.number,
        TokenId.eos,
      ],
      [0, 0, 0, 0, 1, 2, -1],
    );
    expect(tokenizer.getKeyword(ret[0].index), "tank");
    expect(tokenizer.getNumber(ret[1].index), 20);
    expect(tokenizer.getNumber(ret[2].index), 20);
    expect(tokenizer.getNumber(ret[3].index), 20);
    expect(tokenizer.getNumber(ret[4].index), 15);
    expect(tokenizer.getNumber(ret[5].index), 20.1);
  });

  test("Tokenizer_5", () {
    var tokenizer = Tokenizer();
    var ret = tokenizer.tokenize("input 0 1");
    genericTokenTest(
      ret,
      4,
      [
        TokenId.keyword,
        TokenId.number,
        TokenId.number,
        TokenId.eos,
      ],
      [2, 0, 1, -1],
    );
    expect(tokenizer.getKeyword(ret[0].index), "input");
    expect(tokenizer.getNumber(ret[1].index), 0);
    expect(tokenizer.getNumber(ret[2].index), 1);
  });

  test("Tokenizer_6", () {
    var tokenizer = Tokenizer();
    var ret = tokenizer.tokenize("state 0");
    genericTokenTest(
      ret,
      3,
      [
        TokenId.keyword,
        TokenId.number,
        TokenId.eos,
      ],
      [3, 0, -1],
    );
    expect(tokenizer.getKeyword(ret[0].index), "state");
    expect(tokenizer.getNumber(ret[1].index), 0);
  });

  test("Tokenizer_7", () {
    var tokenizer = Tokenizer();
    var ret = tokenizer.tokenize("state open");
    genericTokenTest(
      ret,
      3,
      [
        TokenId.keyword,
        TokenId.identifier,
        TokenId.eos,
      ],
      [3, 0, -1],
    );
    expect(tokenizer.getKeyword(ret[0].index), "state");
    expect(tokenizer.getIdentifier(ret[1].index), "open");
  });

  test("Tokenizer_8", () {
    var tokenizer = Tokenizer();
    var ret = tokenizer.tokenize("link -1 -2");
    genericTokenTest(
      ret,
      4,
      [
        TokenId.keyword,
        TokenId.number,
        TokenId.number,
        TokenId.eos,
      ],
      [4, 0, 1, -1],
    );
    expect(tokenizer.getKeyword(ret[0].index), "link");
    expect(tokenizer.getNumber(ret[1].index), -1);
    expect(tokenizer.getNumber(ret[2].index), -2);
  });

  /////////////////////////////////////////////////////////////////
  /// Widget Tests
  /////////////////////////////////////////////////////////////////
}

void genericTokenTest(
  List<Token> ret,
  int expLen,
  List<TokenId> tokenIds,
  List<int> indices,
) {
  expect(ret.length, expLen);
  for (var i = 0; i < ret.length; ++i) {
    expect(ret[i].id, tokenIds[i]);
  }

  for (var i = 0; i < ret.length; ++i) {
    expect(ret[i].index, indices[i]);
  }
}
