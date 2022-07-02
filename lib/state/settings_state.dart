class SettingsState {
  static double inputObjectWidth = 50;
  static double inputObjectHeight = 50;

  // displayed as circle
  static double lineSegmentEndPointSize = 3.0;
  static double lineSegmentLineSize = 2.5;

  static double tankWidth = 75.0;
  static double tankHeight = 150.0;



  static String title = "SCADA Demo";

  static String debugProg = """
input 0 10 4
 state 1
 sock SE 0 25
tank 100 10 20 500 0
 sock NW 0 45
 link -1 -3
 sock SE 0 25
tank 250 10 20 500 5
 sock SW 0 25
 link -1 -3
 sock SE 0 34
input 350 110 0
 state 0
 sock NW 0 20
 link -1 -3
 sock NE 0 20
 sock NE -100 20
 link -1 -2
 sock NE -100 100
 link -1 -2
 sock SW -300 -55
 link -1 -2
 sock SW -300 -200
 link -1 -2
tank 100 300 20 500 15
 sock N 0 56
 link -1 -3
 sock NE 0 35
input 350 400 0
 state off
 sock NW 0 25
 link -1 -3
 sock NE 0 25
 sock NE -100 25
 link -1 -2
""";
}
