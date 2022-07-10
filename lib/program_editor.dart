import 'dart:async';
import 'package:code_text_field/code_text_field.dart';
import 'package:highlight/languages/xml.dart';
import 'package:flutter/material.dart';
import 'package:waterpark/state/settings_state.dart';
import 'package:waterpark/widgets/event_router.dart';
import 'package:waterpark/widgets/icon_widget.dart';
import 'package:waterpark/widgets/split_widget.dart';
import '../metrics.dart';
import '../palette.dart';
import 'logger.dart';
import 'state/object_state.dart';
import 'state/state_tree_compiler.dart';
import 'state/state_tree.dart';

class ProgramEditor extends StatefulWidget {
  final WorkspaceEventDispatcher dispatcher;

  const ProgramEditor({
    Key? key,
    required this.dispatcher,
  }) : super(key: key);

  @override
  State<ProgramEditor> createState() => _ProgramEditorState();
}

class _ProgramEditorState extends State<ProgramEditor>
    with WorkSpaceEventReceiver {
  late CodeController _controller;
  late FocusNode _editFocus;
  late Timer _triggerBuild;
  late String _lastState;
  late bool _changed;

  @override
  void initState() {
    _editFocus = FocusNode();
    _lastState = widget.dispatcher.text;
    _createController();
    _setupTrigger();

    widget.dispatcher.subscribe(this);

    super.initState();
    _triggerCall();
  }

  @override
  void dispose() {
    SettingsState.position = _controller.selection;
    _triggerBuild.cancel();
    _controller.dispose();
    widget.dispatcher.unsubscribe(this);
    super.dispose();
  }

  void _createController() {
    _controller = CodeController(
      language: xml,
      theme: Palette.programTheme,
      onChange: _triggerChange,
      text: _lastState,
    );
    _changed = true;

    // if (SettingsState.position.base.offset <
    //     _controller.selection.base.offset) {
      _controller.selection = SettingsState.position;
    // }
  }

  void _setupTrigger() {
    _triggerBuild = Timer.periodic(
      const Duration(milliseconds: 500),
      _triggerCallTimer,
    );
  }

  Widget _buildEditor() {
    return ColoredBox(
      color: Palette.editTextWidgetBackground,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCodeTitle(),
          Expanded(
            child: CodeField(
              wrap: false,
              expands: true,
              minLines: null,
              focusNode: _editFocus,
              controller: _controller,
              textStyle: const TextStyle(
                fontFamily: "Mono",
                fontSize: 12,
              ),
              cursorColor: Palette.action,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SplitWidget(
      direction: SplitWidgetDirection.horizontal,
      initialSplit: 0.85,
      childA: _buildEditor(),
      childB: Column(
        children: [
          Expanded(
            child: LogWidget(
              dispatcher: widget.dispatcher,
              logger: widget.dispatcher.logger,
            ),
          ),
        ],
      ),
    );

    // return ColoredBox(
    //   color: Palette.editTextWidgetBackground,
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.start,
    //     crossAxisAlignment: CrossAxisAlignment.stretch,
    //     children: [
    //       _buildCodeTitle(),
    //       Expanded(
    //         child: CodeField(
    //           wrap: false,
    //           expands: true,
    //           minLines: null,
    //           focusNode: _editFocus,
    //           controller: _controller,
    //           textStyle: const TextStyle(
    //             fontFamily: "Mono",
    //             fontSize: 12,
    //           ),
    //           cursorColor: Palette.action,
    //         ),
    //       ),
    //       SizedBox.fromSize(
    //         size: const Size.fromHeight(150),
    //         child: LogWidget(
    //           dispatcher: widget.dispatcher,
    //           logger: widget.dispatcher.logger,
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }

  Widget _buildCodeTitle() {
    return ColoredBox(
      color: Palette.subTitleBackground,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 2, 4),
            child: Text(
              "Edit script",
              style: Common.sizedTextStyle(SettingsState.menuHeight - 2),
            ),
          ),
          const Spacer(),
          IconWidget(
            icon: IconMappings.brush,
            onClick: _clearClicked,
            color: Palette.titleIcon,
            tooltip: "Clears the current text",
            textSize: SettingsState.menuHeight,
          ),
        ],
      ),
    );
  }

  void _triggerChange(newValue) {
    exitTextChanged(newValue);
  }

  Future<List<SimObject>> _compile(String newValue) {
    return Future.microtask(() {
      widget.dispatcher.text = newValue;
      StateTreeCompiler obj = StateTreeCompiler();
      return obj.compile(newValue);
    });
  }

  void exitTextChanged(String newValue) {
    newValue = newValue.trim();
    if (_lastState != newValue) {
      _changed = true;
      _lastState = newValue;
    }
  }

  FutureOr<void> _dispatchTree(value) {
    var result = widget.dispatcher.notifyStateTreeCompiled(
      StateTree(code: value),
    );
    result.then((value) {
      setState(() {
        if (_editFocus.canRequestFocus) {
          _editFocus.requestFocus();
        }
      });
    });
  }

  void _triggerCall() {
    if (_changed) {
      _compile(_lastState).then(_dispatchTree);
      _changed = false;
    }
  }

  void _triggerCallTimer(Timer timer) {
    _triggerCall();
  }

  void _clearClicked() {
    _controller.text = "";
    _lastState = "";
    _changed = true;
    _triggerCall();
  }

  @override
  void onMessageLogged() {
    setState(() {});
  }
}
