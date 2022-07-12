import 'dart:math';

import '../util/double_utils.dart';

class ManifoldUtils {
  static const double atmosphereFt = 29.9212 / 12.0;
  static double velocity = 2;
  static double diameter = 5;
  static double maxFlow = calculateMaxFlow();

  static void setMaxFlow() {
    maxFlow = DoubleUtils.min(calculateMaxFlow(), _maxFlow2());
    //maxFlow = calculateMaxFlow();
  }

  static double calculateMaxFlow() {
    double r = diameter * 0.5;
    double a = (pi * r * r) * 0.25;
    return (velocity * a);
  }

  static double _maxFlow2() {
    return (diameter * diameter) - ((diameter / 2) +2.5);
  }

  static double limit(double rate) {
    return DoubleUtils.min(rate, maxFlow);
  }
}
