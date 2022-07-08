import 'package:waterpark/state/socket_state.dart';
import 'package:waterpark/state/target_ids.dart';
import '../state/manifold_utils.dart';
import '../state/object_state.dart';
import '../state/input_state.dart';
import '../state/tank_state.dart';
import '../util/double_utils.dart';

class StateTreeExecutor {
  final List<SimObject> code;
  final List<InputObject> _flow = [];
  final List<TankObject> _tanks = [];

  StateTreeExecutor.zero() : code = [];
  StateTreeExecutor({required this.code}) {
    _sort();
  }

  void step(double tickMs) {
    tickMs /= 16;
    if (tickMs > 0) tickMs = 1.0 / tickMs;

    _pushIncoming(tickMs);
    _relayTanks(tickMs);
    _equalize(tickMs);
  }

  void _sort() {
    for (SimObject node in code) {
      bool sockType = node is SockObject;
      if (sockType) continue;

      if (node is InputObject) {
        _flow.add(node);
      } else if (node is TankObject) {
        _tanks.add(node);
      }
    }
  }

  void _pushIncoming(double tick) {
    for (var flow in _flow) {
      for (var sock in flow.outputs) {
        sock.cacheValue(
          ManifoldUtils.limit(
            flow.flowRate * tick,
          ),
        );
      }
    }
  }

  void _relayTanks(double tick) {
    for (var tank in _tanks) {
      for (var sock in tank.inputs) {
        if (sock.link != null) {
          tank.addBarrels(sock.link!.getCache());
        }
      }

      int maxOut = 0;

      for (var sock in tank.outputs) {
        double outputHeight = tank.sockHeight(sock);
        if (sock.target == SimTargetId.spill.index &&
            tank.level >= outputHeight) {
          ++maxOut;
        }
      }
      if (maxOut > 0) {
        for (var sock in tank.outputs) {
          double outputHeight = tank.sockHeight(sock);
          if (sock.target == SimTargetId.spill.index &&
              tank.level >= outputHeight) {
            double bbl = tick * (ManifoldUtils.maxFlow / maxOut);
            sock.cacheValue(bbl);
            tank.delBarrels(bbl);
          }
        }
      }
    }
  }

  void _equalize(double tick) {
    double old = ManifoldUtils.velocity;

    for (int i = 1; i < _tanks.length; ++i) {
      TankObject p = _tanks[i - 1];
      TankObject c = _tanks[i];

      double pt = p.equalizeHeight();
      double ct = c.equalizeHeight();

      if (p.level < pt && c.level < ct) continue;

      double a = p.level / 2.31;
      double b = c.level / 2.31;
      double ap = DoubleUtils.abs(a - b);

      ManifoldUtils.velocity = ((a + b) / 2) > old ? old : ((a + b) / 2);
      ManifoldUtils.calculateMaxFlow();

      double d = (ap) * ManifoldUtils.maxFlow;
      double t = DoubleUtils.abs(p.x - c.x) / 20;

      d = (d / t) * tick;
      double ad = DoubleUtils.abs(p.level - c.level);

      if (ad > 0.1) {
        if (p.level >= c.level) {
          p.delBarrels(d);
          c.addBarrels(d);
        } else {
          p.addBarrels(d);
          c.delBarrels(d);
        }
      }
    }
    ManifoldUtils.velocity = old;
    ManifoldUtils.calculateMaxFlow();
  }
}
