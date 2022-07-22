import 'parser.dart';

class PrintLogger extends XmlParseLogger {
  @override
  void log(String message) {
    // ignore: avoid_print
    print(message);
  }

  @override
  void clear() {}
}
