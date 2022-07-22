import 'dart:math';
import '../util/double_utils.dart';

class ManifoldUtils {
  static const double atmosphereFt = 29.9212 / 12.0;
  static double velocity = 2;

  /// The diameter of the manifold in inches
  static double diameter = 5;
  static double maxFlow = calculateMaxFlow();

  static get diameterFeet => diameter * 0.8333333333;
  static get upperBound => (diameter * diameter);

  // https://www.desmos.com/calculator/djqcupmrjz

  static double calculateMaxFlow() {
    maxFlow = DoubleUtils.min(velocity * pi * diameter, upperBound);
    return maxFlow;
  }

  static double limit(double rate) {
    return DoubleUtils.min(rate, calculateMaxFlow());
  }
}
