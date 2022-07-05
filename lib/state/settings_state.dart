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

  // general border
  static double border = 3.0;
  static String title = "Water Facility Demo";

  static String debugProg = """
input 0 10 6
 state 0
 sock NE 0 18
tank 100 10 20 500 1
 sock NW 0 20 
link -1 -3
 sock NE 0 35.5
tank 200 10 20 500 1
 sock NW 0 35.5
 link -1 -3
 sock SE 0 35.5
tank 300 10 20 500 1
 sock SW 0 35.5
 link -1 -3
 sock SE 0 35.5
 sock SE -20 35.5
 link -1 -2
 sock SE -20 -8
 link -1 -2
tank 100 170 20 500 1
 sock NW  -10 -7
 link -1 -3
 sock SW -10 35.5
 link -1 -2
 sock SW 0 35.5
 link -1 -2
 sock SE 0 35.5
tank 200 170 20 500 1
 sock SW 0 35.5
 link -1 -3
 sock SE 0 35.5
tank 300 170 20 500 5
 sock SW 0 35.5
 link -1 -3
 sock SE 0 35.5
""";
}
