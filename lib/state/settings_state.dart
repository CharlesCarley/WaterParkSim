import 'package:flutter/material.dart';

class SettingsState {
  static double inputObjectWidth = 50;
  static double inputObjectHeight = 50;

  // displayed as circle
  static double lineSegmentEndPointSize = 3.0;
  static double lineSegmentLineSize = 2.5;

  static double tankWidth = 75.0;
  static double tankHeight = 150.0;
  static double menuHeight = 14.0;
  static int displayPrecision = 2;

  static double sashPos = 0.28;

  static int stepRateMs = 60;

  static TextSelection position = TextSelection.fromPosition(
    const TextPosition(offset: 0),
  );

  // general border
  static double border = 3.0;
  static String title = "Water Facility Demo";
  static String debugProg = """
<page>
    <manifold dia="6" vel="4"/> 
    <!-- 
    Incoming @ 3 bbl/min 
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
    <tank param="510,10,20,500,15">
        <isock param="S,0,21.6"  
               link="4" 
               target="eq" />
        <osock param="SE,0,21.6" 
               id="5"   
               target="eq" />
    </tank>
</page>
""";
}
