// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'package:flutter_test/flutter_test.dart';
import 'package:waterpark_frontend/state/socket_object.dart';
import 'package:waterpark_frontend/state/tank_object.dart';
import 'package:waterpark_frontend/tokenizer/sim_builder.dart';
import 'package:waterpark_frontend/tokenizer/tokenizer.dart';

void main() {
  test('smoke_test1', () {
    var tokenizer = Tokenizer();
    var ret = tokenizer.tokenize("-1  a  b  c");
    expect(ret.length, 5);
    expect(ret[0].id, TokenId.number);
    expect(ret[1].id, TokenId.identifier);
    expect(ret[2].id, TokenId.identifier);
    expect(ret[3].id, TokenId.identifier);
    expect(ret[4].id, TokenId.eos);

    expect(ret[0].index, 0);
    expect(ret[1].index, 0);
    expect(ret[2].index, 1);
    expect(ret[3].index, 2);
    expect(ret[4].index, -1);

    expect(tokenizer.getNumber(ret[0].index), -1.0);
    expect(tokenizer.getIdentifier(ret[1].index), "a");
    expect(tokenizer.getIdentifier(ret[2].index), "b");
    expect(tokenizer.getIdentifier(ret[3].index), "c");
  });
  test('smoke_test2', () {
    var tokenizer = Tokenizer();
    var ret = tokenizer.tokenize("tank 20 20 20 15 20.1");
    expect(ret.length, 7);
    expect(ret[0].id, TokenId.keyword);
    expect(ret[1].id, TokenId.number);
    expect(ret[2].id, TokenId.number);
    expect(ret[3].id, TokenId.number);
    expect(ret[4].id, TokenId.number);
    expect(ret[5].id, TokenId.number);
    expect(ret[6].id, TokenId.eos);

    expect(ret[0].index, 0);
    expect(ret[1].index, 0);
    expect(ret[2].index, 0);
    expect(ret[3].index, 0);
    expect(ret[4].index, 1);
    expect(ret[5].index, 2);

    expect(tokenizer.getNumber(ret[1].index), 20);
    expect(tokenizer.getNumber(ret[2].index), 20);
    expect(tokenizer.getNumber(ret[3].index), 20);
    expect(tokenizer.getNumber(ret[4].index), 15);
    expect(tokenizer.getNumber(ret[5].index), 20.1);
    expect(tokenizer.getKeyword(ret[0].index), "tank");
  });

  test('smoke_test3', () {
    var parser = SimBuilder();
    var ret = parser.parse("tank 20 20 25 625 15 ");

    expect(ret.length, 1);

    var t = ret[0] as TankObject;
    expect(t.x, 20);
    expect(t.y, 20);
    expect(t.height, 25);
    expect(t.capacity, 625);
    expect(t.level, 15);
  });

  test('smoke_test3', () {
    var parser = SimBuilder();
    var ret = parser.parse("tank 20 20 25 625 15 "
        "sock N 0 0 "
        "sock E 0 0 "
        "sock S 0 0 "
        "sock W 0 0 ");

    var t = ret[0] as TankObject;
    expect(t.x, 20);
    expect(t.y, 20);
    expect(t.height, 25);
    expect(t.capacity, 625);
    expect(t.level, 15);

    List<int> bits = [SocketBits.N, SocketBits.E, SocketBits.S, SocketBits.W];
    for (int i = 0; i < bits.length; ++i) {
      var s = ret[1 + i] as SockObject;
      expect(s.dir, bits[i]);
      expect(s.dx, 0);
      expect(s.dy, 0);
    }
  });
}
