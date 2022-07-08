class SettingsState {
  static double inputObjectWidth = 50;
  static double inputObjectHeight = 50;

  // displayed as circle
  static double lineSegmentEndPointSize = 3.0;
  static double lineSegmentLineSize = 2.5;

  static double tankWidth = 75.0;
  static double tankHeight = 150.0;
  static double menuHeight = 18.0;
  static int displayPrecision = 2;
 
  static double sashPos = 0.25;

  static int stepRateMs = 60;
  

  // general border
  static double border = 3.0;
  static String title = "Water Facility Demo";

  static String debugProg = """
<page>
    <input param="10,10,4" 
           state="on">
        <osock param="NE,0,15" 
               id="0" />
    </input>
    <tank param="110,10,20,500,0">
        <isock param="N,0,20"  
               link="0" 
               target="dump" />
        <osock param="NE,0,20" 
               id="1"   
               target="spill" />
    </tank>
    <tank param="210,10,20,500,1">
        <isock param="N,0,20"  
               link="1" 
               target="dump" />
        <osock param="SE,0,20" 
               id="2"   
               target="eq" />
    </tank>
    <tank param="310,10,20,500,15">
        <isock param="S,0,20"  
               link="2" 
               target="eq" />
        <osock param="SE,0,20" 
               id="3"   
               target="eq" />
    </tank>
</page>
""";
}
