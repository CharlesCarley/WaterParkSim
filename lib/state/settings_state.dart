import 'package:flutter/material.dart';

class SettingsState {
  static double inputObjectWidth = 50;
  static double inputObjectHeight = 30;

  static double pumpObjectWidth = 50;
  static double pumpObjectHeight = 50;

  // displayed as circle
  static double lineSegmentEndPointSize = 3.0;
  static double lineSegmentLineSize = 2.5;

  static double tankWidth = 75.0;
  static double tankHeight = 150.0;
  static double menuHeight = 14.0;
  static int displayPrecision = 3;

  static double sashPos = 0.28;

  static int stepRateMs = 60;

  static TextSelection position = TextSelection.fromPosition(
    const TextPosition(offset: 1),
  );

  // general border
  static double border = 3.0;
  static String title = "Water Facility Demo";
  static String debugProg = """
<page>
  <manifold dia="6" vel="4"/> 
  <!-- 
  Incoming @ 6 bbl/min 
  -->
  <input param="10,10,6" 
         state="on">
    <osock param="NE,0,6" 
           id="0" />
  </input>
  <!-- 
  Dumping into a 20 ft/500 bbl 
  tank that spills over @ 18 ft
  -->
  <tank param="110,10,20,500,0">
    <isock param="N,0,6"  
           link="0" 
           target="dump" />
     
    <osock param="NE,0,16" 
           id="1"   
           target="spill" />
  </tank>
  <!-- 
  Equalizing between 4, 20 ft/500 bbl 
  tanks with a manifold height of 3ft
  -->
  <tank param="210,10,20,500,1">
    <isock param="N,0,16"  
           link="1" 
           target="dump" />
    <osock param="SE,0,21.6" 
           id="2"   
           target="eq" />
  </tank>
  <tank param="310,10,20,500,2">
    <isock param="S,0,21.6"  
           link="2" 
           target="eq" />
    <osock param="SE,0,21.6" 
           id="3"   
           target="eq" />
  </tank>
  <tank param="410,10,20,500,2">
    <isock param="S,0,21.6"  
           link="3" 
           target="eq" />
    <osock param="SE,0,21.6" 
           id="4"   
           target="eq" />
  </tank>
  <tank param="510,10,20,500,15" 
        id="trigger">
    <isock param="S,0,21.6"  
           link="4" 
           target="eq" />
    <osock param="SE,0,21.6" 
           id="5"   
           target="suction" />
  </tank>
  <!-- 
  Pull from the tank battery @ 12 bbl/min 
  when the tank with the id 'trigger' goes 
  above 16 ft. Shut it down when tank level 
  reaches 5 ft. 
  -->
  <pump param="600,110,12" 
        state="off">
    <trigger start="16" 
             stop="5" 
             link="trigger"/>
    <isock param="NW,0,25"
           link="5"
           target="suction" />
    <osock param="NE,0,25" 
           id="6"   
           target="discharge" />
  </pump>
</page>
""";
}
