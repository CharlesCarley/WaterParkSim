import 'package:flutter/material.dart';
import 'dart:async';

import 'package:code_text_field/code_text_field.dart';
import 'package:highlight/languages/xml.dart';

import 'state/settings_state.dart';
import 'widgets/event_router.dart';
import 'widgets/icon_widget.dart';
import 'widgets/split_widget.dart';
import 'palette.dart';
import 'logger.dart';
import 'state/object_state.dart';
import 'state/state_tree_compiler.dart';
import 'state/state_tree.dart';
import 'widgets/toolbar_widget.dart';

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
    Settings.position = _controller.selection;
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
    _controller.selection = Settings.position;
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
          ToolbarWidget(
            title: "Edit",
            tools: [
              IconWidget(
                icon: IconMappings.brush,
                onClick: _clearClicked,
                color: Palette.titleIcon,
                tooltip: "Clears the current text",
              ),
            ],
          ),
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
  }

  void _triggerChange(newValue) {
    exitTextChanged(newValue);
  }

  Future<StateTreeCompiler> _compile(String newValue) {
    return Future.microtask(() {
      widget.dispatcher.text = newValue;
      StateTreeCompiler obj = StateTreeCompiler();
      obj.compile(newValue);
      return obj;
    });
  }

  void exitTextChanged(String newValue) {
    newValue = newValue.trim();
    if (_lastState != newValue) {
      _changed = true;
      _lastState = newValue;
    }
  }

  FutureOr<void> _dispatchTree(StateTreeCompiler obj) {
    var result = widget.dispatcher.notifyStateTreeCompiled(
      StateTree(code: obj.code, tick: obj.tick),
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
