import 'package:flutter/material.dart';

/// Defines application wide settings. For a regular application these settings
/// should be persisted to an application database.
class Settings {
  /// Defines the width for the dashboard/InputObject type.
  static double inputObjectWidth = 50;

  /// Defines the height for the dashboard/InputObject type.
  static double inputObjectHeight = 30;

  /// Defines the width for the dashboard/PumpObject type.
  static double pumpObjectWidth = 50;

  /// Defines the height for the dashboard/PumpObject type.
  static double pumpObjectHeight = 50;

  /// Defines the socket connection radius
  static double lineSegmentEndPointSize = 3.0;

  /// Defines the line width for the line segment between sockets.
  static double lineSegmentLineSize = 2.5;

  /// Defines the width for the dashboard/TankObject type.
  static double tankWidth = 75.0;

  /// Defines the height for the dashboard/TankObject type.
  static double tankHeight = 150.0;

  /// Defines the height for the toolbar widget.
  static double menuHeight = 14.0;

  /// Defines the number of digits displayed for canvas text.
  static int displayPrecision = 3;

  /// Defines the initial workspace split position. [0,1]
  static double sashPos = 0.28;

  /// Defines the timer update interval in milliseconds.
  /// Realtime 60 * 1000 equals 1 minute.
  /// Speed up 60 ms equals 1 minute.
  static int stepRateMs = 60;

  /// Used to cache the cursor position.
  static TextSelection position = TextSelection.fromPosition(
    const TextPosition(offset: 1),
  );

  /// Defines the border around dashboard objects.
  static double border = 2.0;

  /// Defines the title-bar text.
  static String title = "Water Facility Demo";

  /// Defines the default script for the editor on application startup.
  static String debugProg = """
<page tick="1000">
  <manifold dia="6" vel="6"/> 
  <!-- 
  Incoming @ 6 bbl/min 
  -->
  <input param="5,10,12" 
         state="on">
    <osock param="NE,0,6" 
           id="0" />
  </input>
  <!-- 
  Dumping into a 20 ft/500 bbl 
  tank that spills over @ 18 ft
  -->
  <tank param="100,10,20,500,0">
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
  <pump param="600,110,36" 
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
