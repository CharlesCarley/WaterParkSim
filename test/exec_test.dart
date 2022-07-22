// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:waterpark/main.dart';
import 'package:waterpark/simulation/state_execute.dart';
import 'package:waterpark/state/state_tree_compiler.dart';
import 'package:waterpark/xml/print_logger.dart';

StateTreeExecutor setupCode(String buffer) {
  StateTreeCompiler compiler = StateTreeCompiler();
  compiler.compile(buffer);

  return StateTreeExecutor(
    code: compiler.code,
    rate: 1000,
  );
}

void main() {
  logger = PrintLogger();

  test("EXE_Test_1", () {
    StateTreeExecutor exe = setupCode("""
<page>
  <manifold dia="6" vel="4"/> 
 
 
  <input param="10,10,6.00" 
         state="on">
    <osock param="NE,0,6" 
           id="0" />
  </input>
 
 
  <tank param="110,10,20,500,0">

    <isock param="N,0,6"  
           link="0" 
           target="dump" />
     
    <osock param="NE,0,16" 
           id="1"   
           target="spill" />
  </tank>

</page>
""");
    exe.step(60);
  });
}
