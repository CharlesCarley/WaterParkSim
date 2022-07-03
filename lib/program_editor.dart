import 'dart:async';
import 'package:flutter/material.dart';
import 'package:waterpark/widgets/event_router.dart';

import '../metrics.dart';
import '../palette.dart';
import '../state/common_state.dart';
import '../state/state_manager.dart';
import '../tokenizer/sim_builder.dart';

class ProgramEditor extends StatefulWidget {
  final String program;
  final WorkspaceEventDispatcher dispatcher;

  const ProgramEditor({
    Key? key,
    required this.program,
    required this.dispatcher,
  }) : super(key: key);

  @override
  State<ProgramEditor> createState() => _ProgramEditorState();
}

class _ProgramEditorState extends State<ProgramEditor>
    with WorkSpaceEventReceiver {
  late FocusNode _editFocus;
  late TextEditingController _controller;
  late Timer _triggerBuild;
  late String _lastState;
  late bool _changed;

  @override
  void initState() {
    _controller = TextEditingController();
    _controller.text = widget.dispatcher.text;
    _lastState = widget.dispatcher.text;

    _editFocus = FocusNode();

    _triggerBuild = Timer.periodic(
      const Duration(milliseconds: 500),
      _triggerCallTimer,
    );

    super.initState();
    _changed = true;
    _triggerCall();
  }

  @override
  void dispose() {
    _triggerBuild.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Palette.editTextWidgetBackground,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: TextFormField(
              validator: null,
              onSaved: null,
              onChanged: _triggerChange,
              autofocus: false,
              focusNode: _editFocus,
              controller: _controller,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              cursorColor: Palette.action,
              style: Common.editTextStyle,
              decoration: Common.defaultTextDecoration,
            ),
          ),
        ],
      ),
    );
  }

  void _triggerChange(newValue) {
    exitTextChanged(newValue);
  }

  Future<List<Node>> _compile(String newValue) {
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
}
