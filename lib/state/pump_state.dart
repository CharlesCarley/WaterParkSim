import 'settings_state.dart';
import 'tank_state.dart';
import 'toggle_state.dart';

class PumpObject extends ToggleObject {
  double pumpRate;
  TankObject? levelMonitor;
  double levelStart = 0;
  double levelStop = 0;
  

  PumpObject({
    required double x,
    required double y,
    required this.pumpRate,
    required bool state,
  }) : super(
          x: x,
          y: y,
          w: SettingsState.pumpObjectWidth,
          h: SettingsState.pumpObjectHeight,
          toggle: state,
        );
}
