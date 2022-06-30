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
import 'package:flutter_quill/flutter_quill.dart';

import '../metrics.dart';
import '../palette.dart';
import '../state/node.dart';
import '../tokenizer/sim_builder.dart';

class ProgramEditor extends StatefulWidget {
  final String program;
  final NodeManager manager;

  const ProgramEditor({
    Key? key,
    required this.program,
    required this.manager,
  }) : super(key: key);

  @override
  State<ProgramEditor> createState() => _ProgramEditorState();
}

class _ProgramEditorState extends State<ProgramEditor> {
  late FocusNode _editFocus;
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    _controller.text = widget.program;
    _editFocus = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        border: Border.all(color: Palette.editTextWidgetBorder),
      ),
      child: ColoredBox(
        color: Palette.editTextWidgetBackground,
        child: Column(
          children: [
            Expanded(
              child: TextFormField(
                onChanged: (value) => exitTextChanged(value),
                autofocus: true,
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
      ),
    );
  }

  Future<List<Node>> update(String newValue) {
    return Future.microtask(() {
      SimBuilder parser = SimBuilder();
      return parser.parse(newValue);
    });
  }

  void exitTextChanged(String newValue) async {
    update(newValue).then((value) => widget.manager.apply(value));
  }
}

class QullProgramEditor extends StatelessWidget {
  final QuillController _controller = QuillController.basic();

  QullProgramEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      QuillToolbar.basic(controller: _controller),
      Expanded(
        child: QuillEditor.basic(
          controller: _controller,
          readOnly: false, // true for view only mode
        ),
      )
    ]);
  }
}
