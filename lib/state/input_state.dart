import 'settings_state.dart';
import 'toggle_state.dart';




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
          w: SettingsState.inputObjectWidth,
          h: SettingsState.inputObjectHeight,
          toggle: state,
        );
}
