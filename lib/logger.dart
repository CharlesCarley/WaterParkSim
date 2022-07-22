import 'package:flutter/material.dart';

import 'metrics.dart';
import 'main.dart';
import 'palette.dart';
import 'widgets/event_router.dart';
import 'widgets/icon_widget.dart';
import 'widgets/toolbar_widget.dart';
import 'xml/parser.dart';

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
    double dig = Styles.editTextSize * len.toDouble();

    for (int idx = 0; idx < messages.length; ++idx) {
      var str = messages[idx];
      var strIdx = idx + 1;

      Color col = idx % 2 == 0
          ? Palette.controlBackground
          : Palette.controlBackgroundLight;

      ret.add(Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 8, 0),
              child: SizedBox(
                width: dig,
                child: Text(
                  strIdx.toString(),
                  style: Styles.editTextStyle,
                  textAlign: TextAlign.end,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: ColoredBox(
              color: col,
              child: Text(
                str,
                style: Styles.editTextStyle,
              ),
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
        ToolbarWidget(
          title: "Output",
          tools: [
            IconWidget(
              icon: IconMappings.brush,
              onClick: () {
                setState(() {
                  logger.clear();
                });
              },
            )
          ],
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
