import 'dart:math';

import 'package:waterpark/util/double_utils.dart';

class ManifoldUtils {
  static double velocity = 8;
  static double diameter = 4;
  static double maxFlow = calculateMaxFlow();

  static double calculateMaxFlow() {
    double r = diameter / 12;
    double a = (pi * r * r) / 4;
    return (448.8*velocity * a)/42.0;
  }

  static double limit(double rate) {
    return DoubleUtils.min(rate, maxFlow);
  }
}
