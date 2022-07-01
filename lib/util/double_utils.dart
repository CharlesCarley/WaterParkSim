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
}
