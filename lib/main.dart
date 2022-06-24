import 'package:flutter/material.dart';
import 'package:waterpark_frontend/metrics.dart';
import 'package:waterpark_frontend/palette.dart';

void main() {
  runApp(const MyApp());
}

class Constants {
  static const TankWidth = 75.0;
  static const TankHeight = 150.0;
}

class LabelWidget extends StatelessWidget {
  final Color color;
  final String text;
  final double x;
  final double y;
  final double size = 14;

  const LabelWidget(this.x, this.y, this.color, this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final Size textSize = Metrics.measureSizedText(text, size);

    return Positioned.fromRect(
      rect: Rect.fromLTRB(x, y, x+textSize.width, y+textSize.height),
      child: Text(
        text,
        style: Common.editTextStyle,
      ),
    );
  }
}

////////////////////////////////////////////////////////////////
class TankWidget extends StatelessWidget {
  final double x, y;
  final double Padding = 4;
  final double TankHeight;
  final double WaterHeight;

  const TankWidget(this.x, this.y, this.TankHeight, this.WaterHeight,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Rect base =
        Rect.fromLTRB(x, y, x + Constants.TankWidth, y + Constants.TankHeight);
    final Rect inner = Rect.fromLTRB(base.left + Padding, base.top + Padding,
        base.right - Padding, base.bottom - Padding);

    final double tr = inner.bottom - inner.top;
    final double ar = WaterHeight / TankHeight;

    final Rect vrect = Rect.fromLTRB(
      inner.left,
      inner.bottom - ((ar * tr)),
      inner.right,
      inner.bottom,
    );

    return Stack(children: [
      RectWidget(
        base,
        Color.fromARGB(255, 62, 62, 62),
      ),
      RectWidget(
        inner,
        Color.fromARGB(255, 19, 19, 19),
      ),
      RectWidget(
        vrect,
        Color.fromARGB(255, 85, 79, 194),
      ),
      LabelWidget(inner.left, inner.top, Palette.action, ar.toString()),
      
    ]);
  }
}

////////////////////////////////////////////////////////////////
class RectWidget extends StatelessWidget {
  final Rect rect;
  final Color color;

  const RectWidget(this.rect, this.color, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: rect,
      child: ColoredBox(color: color),
    );
  }
}

////////////////////////////////////////////////////////////////
class StackedCanvas extends StatefulWidget {
  const StackedCanvas({Key? key}) : super(key: key);

  @override
  State<StackedCanvas> createState() => _StackedCanvasState();
}

class _StackedCanvasState extends State<StackedCanvas> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(0xFF, 0x1B, 0x1B, 0x1B),
      body: Stack(children: getChildren()),
    );
  }

  List<Widget> getChildren() {
    List<double> statList = [
      20,
      19,
      18,
      17,
      16,
      15,
      14,
      13,
      12,
      11,
      10,
      9,
      8,
      7,
      6,
      5,
      4,
      3,
      2,
      1,
      0
    ];

    List<Widget> wlist = [];
    double x = 20;
    double y = 20;

    const int maxPerLline = 5;
    int perLine = 0;

    for (var d in statList) {
      wlist.add(new TankWidget(x, y, 20, d));
      x += Constants.TankWidth + 10;
      ++perLine;

      if (perLine > maxPerLline) {
        y += Constants.TankHeight + 10;
        perLine = 0;
        x = 20;
      }
    }
    return wlist;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.grey,
      ),
      home: const MyHomePage(title: 'WaterPark Simulator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "ABC",
      home: StackedCanvas(),
    );
  }
}
