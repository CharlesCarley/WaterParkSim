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
 
  static double sashPos = 0.5;
 
  // general border
  static double border = 3.0;
  static String title = "Water Facility Demo";

  static String debugProg = """
<page>
  <input x="10" y="10" rate="6" state="on">
    <osock id="0" dir="NE" dx="0" dy="15"/>
  </input>
  
  <tank x="110" y="10" height="20" capacity="500" level="0">
    <isock dir="N" dx="0" dy="20" link="0" target="dump"/>
    <osock id="1" dir="NE" dx="0" dy="20" target="spill"/>
  </tank>

  <tank x="210" y="10" height="20" capacity="500" level="3">
    <isock dir="N" dx="0" dy="20" link="1" target="dump"/>
    <osock id="2" dir="SE" dx="0" dy="20"  target="eqManifold"/>
  </tank>

  <tank x="310" y="10" height="20" capacity="500" level="3">
    <isock dir="S" dx="0" dy="20" link="2" target="eqManifold"/>
    <osock id="3" dir="SE" dx="0" dy="20" target="eqManifold"/>
  </tank>
</page>
""";
}
