/*
-------------------------------------------------------------------------------
    Copyright (c) Charles Carley.

  This software is provided 'as-is', without any express or implied
  warranty. In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.
-------------------------------------------------------------------------------
*/
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:waterpark_frontend/widgets/event_router.dart';

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
    _changed = false;

    _editFocus = FocusNode();

    _triggerBuild = Timer.periodic(
      const Duration(seconds: 1),
      _triggerCall,
    );

    super.initState();
    exitTextChanged(widget.dispatcher.text);
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
    // await _compile(newValue).then(_dispatchTree);
  }

  FutureOr<void> _dispatchTree(value) {
    var result = widget.dispatcher.notifyStateTreeCompiled(
      // reconstruct the tree with the new value...
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

  void _triggerCall(Timer timer) {
    if (_changed) {
      _compile(_lastState).then(_dispatchTree);
      _changed = false;
    }
  }
}
