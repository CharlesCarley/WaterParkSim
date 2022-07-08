class DoubleUtils {
  static double min(double a, double b) {
    return a < b ? a : b;
  }

  static double max(double a, double b) {
    return a > b ? a : b;
  }

  static double lim(double v, double a, double b) {
    return v < a
        ? a
        : v > b
            ? b
            : v;
  }

  static void limDv(double v, double a, double b) {
    if (v < a) v = a;
    if (v > b) v = b;
  }

  static void limIv(int v, int a, int b) {
    if (v < a) v = a;
    if (v > b) v = b;
  }

  static double abs(double v) {
    return v < 0 ? -v : v;
  }

  static double fromString(String s, {double def = 0}) {
    var v = double.tryParse(s);
    if (v != null) return v;
    return def;
  }
}
