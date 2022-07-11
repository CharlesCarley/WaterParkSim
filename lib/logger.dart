import 'package:flutter/material.dart';
import 'package:waterpark/main.dart';
import 'package:waterpark/palette.dart';
import 'package:waterpark/state/settings_state.dart';
import 'package:waterpark/widgets/event_router.dart';
import 'package:waterpark/widgets/icon_widget.dart';
import 'package:waterpark/xml/parser.dart';

import '../metrics.dart';

class XmlListLogger extends XmlParseLogger {
  final List<String> messages = [];
  final WorkspaceEventDispatcher dispatcher;

  XmlListLogger(this.dispatcher);

  @override
  void log(String message) {
    messages.add(message);
    dispatcher.notifyMessageLogged();
  }

  void clear() {
    messages.clear();
  }

  List<Widget> getMessages() {
    List<Widget> ret = [];

    int len = messages.length.toString().length;
    double dig = Common.editTextSize * len.toDouble();

    for (int idx = 0; idx < messages.length; ++idx) {
      var str = messages[idx];
      var strIdx = idx + 1;
      ret.add(Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 8, 0),
            child: SizedBox(
              width: dig,
              child: Text(
                strIdx.toString(),
                style: Common.editTextStyle,
                textAlign: TextAlign.end,
              ),
            ),
          ),
          Expanded(
            child: Text(
              str,
              style: Common.editTextStyle,
            ),
          ),
        ],
      ));
    }
    return ret;
  }
}

class LogWidget extends StatefulWidget {
  final XmlListLogger logger;
  final WorkspaceEventDispatcher dispatcher;

  const LogWidget({
    required this.logger,
    required this.dispatcher,
    Key? key,
  }) : super(key: key);

  @override
  State<LogWidget> createState() => _LogWidgetState();
}

class _LogWidgetState extends State<LogWidget> with WorkSpaceEventReceiver {
  late ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();
    widget.dispatcher.subscribe(this);
    super.initState();
  }

  @override
  void dispose() {
    widget.dispatcher.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ColoredBox(
          color: Palette.subTitleBackground,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                child: Text(
                  "Output",
                  style: Common.sizedTextStyle(SettingsState.menuHeight-2),
                ),
              ),
              const Spacer(),
              IconWidget(
                icon: IconMappings.brush,
                textSize: SettingsState.menuHeight,
                onClick: () {
                  setState(() {
                    logger.clear();
                  });
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            controller: _controller,
            children: widget.logger.getMessages(),
          ),
        ),
      ],
    );
  }

  @override
  void onMessageLogged() {
    _controller.position.animateTo(
      _controller.position.maxScrollExtent,
      duration: const Duration(milliseconds: 20),
      curve: Curves.bounceIn,
    );
  }
}
