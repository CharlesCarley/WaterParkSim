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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'metrics.dart';
import 'palette.dart';

typedef StringCallback = void Function(String text);

class TextEditor extends StatelessWidget {
  final TextEditingController controller;
  final Rect rect;
  final FocusNode focus;

  const TextEditor({
    Key? key,
    required this.rect,
    required this.controller,
    required this.focus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: TextFormField(
            onChanged: (value) => {
              
            },
            autofocus: true,
            focusNode: focus,
            controller: controller,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            cursorColor: Palette.action,
            style: Common.editTextStyle,
            decoration: Common.defaultTextDecoration,
          ),
        ),
      ],
    );
  }
}

class EditProgram extends StatefulWidget {
  final StringCallback onOkClicked;
  final VoidCallback onCancelClicked;
  final String program;

  const EditProgram({
    Key? key,
    required this.program,
    required this.onOkClicked,
    required this.onCancelClicked,
  }) : super(key: key);

  @override
  State<EditProgram> createState() => _EditProgramState();
}

class _EditProgramState extends State<EditProgram> {
  late String _errorText;
  late FocusNode _keyboardFocus;
  late FocusNode _editFocus;
  late TextEditingController _controller;

  @override
  void initState() {
    _errorText = "";

    _controller = TextEditingController();
    _controller.text = widget.program;

    _keyboardFocus = FocusNode();
    _keyboardFocus.requestFocus();

    _editFocus = FocusNode();
    _editFocus.requestFocus();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void handleKey(RawKeyEvent value) {
    if (value.physicalKey == PhysicalKeyboardKey.escape) {
      widget.onCancelClicked();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      onKey: handleKey,
      focusNode: _keyboardFocus,
      child: Container(
        padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
        decoration: BoxDecoration(
          border: Border.all(color: Palette.editTextWidgetBorder),
         ),
        child: ColoredBox(
          color: Palette.editTextWidgetBackground,
          child: Stack(
            children: [
              TextEditor(
                rect: Rect.fromLTRB(0, 0, 80, 90),
                focus: _editFocus,
                controller: _controller,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
