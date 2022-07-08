import 'package:flutter/material.dart';
import 'package:waterpark/widgets/compile_log.dart';
import 'package:waterpark/workspace.dart';

import 'widgets/event_router.dart';

late XmlListLogger logger;

void logMessage(String message) {
  logger.log(message);
}

WorkspaceEventDispatcher initDispatcher() {
  WorkspaceEventDispatcher dispatcher = WorkspaceEventDispatcher();
  logger = dispatcher.logger = XmlListLogger(dispatcher);
  return dispatcher;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  var disp = initDispatcher();
  runApp(WaterParkSimulator(dispatcher: disp));
}
