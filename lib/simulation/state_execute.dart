import 'package:waterpark/state/pump_state.dart';
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
  final List<PumpObject> _pumps = [];

  StateTreeExecutor.zero() : code = [];
  StateTreeExecutor({required this.code}) {
    _sort();
  }

  void step(double tickMs) {
    tickMs /= 16;
    if (tickMs > 0) tickMs = 1.0 / tickMs;

    _pushIncoming(tickMs);
    _relayTanks(tickMs);
    _runPumps(tickMs);
    _equalize(tickMs);
  }

  void _sort() {
    ManifoldUtils.setMaxFlow();

    for (SimObject node in code) {
      bool sockType = node is SockObject;
      if (sockType) continue;

      if (node is InputObject) {
        _flow.add(node);
      } else if (node is TankObject) {
        _tanks.add(node);
      } else if (node is PumpObject) {
        _pumps.add(node);
      }
    }
  }

  void _pushIncoming(double tick) {
    for (var flow in _flow) {
      if (flow.toggle) {
        for (var sock in flow.outputs) {
          sock.cacheValue(
            ManifoldUtils.limit(
              flow.flowRate * tick,
            ),
          );
        }
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

      if (!p.canEqualize()) continue;

      double pt = p.equalizeHeight();
      double ct = c.equalizeHeight();

      if (p.level < pt && c.level < ct) continue;

      double a = p.psi;
      double b = c.psi;
      double ap = DoubleUtils.abs(a - b);

      ManifoldUtils.velocity = ((a + b) * 0.5) > old ? old : ((a + b) * 0.5);
      ManifoldUtils.calculateMaxFlow();

      double d = (ap) * ManifoldUtils.maxFlow;

      // disabled: calculate the relative distance between
      //   sockets and factor in the distance traveled through
      //   the manifold. needs (a.right - b.left) | vice versa.
      double t = 1; //DoubleUtils.abs(p.x - c.x) / 10;

      d = (d / t) * tick;
      double ad = DoubleUtils.abs(p.level - c.level);

      if (ad > 0.0001) {
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

  void _runPumps(double tickMs) {
    for (var pump in _pumps) {
      if (!pump.toggle) {
        _monitorLink(pump);
      } else {
        _runPump(tickMs, pump);
      }
    }
  }

  void _monitorLink(PumpObject pump) {
    if (pump.levelMonitor == null) return;

    TankObject tank = pump.levelMonitor!;
    if (tank.level >= pump.levelStart) {
      pump.toggle = true;
    }
  }

  void _runPump(double tickMs, PumpObject pump) {
    if (pump.levelMonitor == null) return;

    TankObject tank = pump.levelMonitor!;
    if (tank.level <= pump.levelStop) {
      pump.toggle = false;
    } else {
      double old = ManifoldUtils.velocity;

      double v = pump.pumpRate * tank.psi;
      ManifoldUtils.velocity = v;
      ManifoldUtils.calculateMaxFlow();

      double cr = ManifoldUtils.limit(pump.pumpRate);
      tank.delBarrels(cr * tickMs);

      ManifoldUtils.velocity = old;
      ManifoldUtils.calculateMaxFlow();
    }
  }
}
