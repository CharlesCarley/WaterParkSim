import 'toggle_object.dart';
const double inputObjectWidth = 50;
const double inputObjectHeight = 50;



class InputObject extends ToggleObject {
  double flowRate;

  InputObject({
    required double x,
    required double y,
    required this.flowRate,
    required bool state,
  }) : super(
          x: x,
          y: y,
          w: inputObjectWidth,
          h: inputObjectHeight,
          toggle: state,
        );
}
