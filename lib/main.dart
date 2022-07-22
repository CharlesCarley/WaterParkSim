import 'package:flutter/material.dart';

import 'workspace.dart';
import 'logger.dart';
import 'widgets/event_router.dart';
import 'xml/parser.dart';

late XmlParseLogger logger;

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
  runApp(WaterParkSimulator(dispatcher: initDispatcher()));
}
