import 'package:flutter/material.dart';
import '../metrics.dart';
import '../palette.dart';
import '../state/settings_state.dart';
import 'icon_widget.dart';

class ToolbarWidget extends StatelessWidget {
  final List<IconWidget> tools;
  final String title;

  const ToolbarWidget({
    required this.title,
    required this.tools,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Palette.subTitleBackground,
      child: Row(
        children: _buildItems(),
      ),
    );
  }

  List<Widget> _buildItems() {
    List<Widget> items = [
      Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: Text(
          title,
          style: Common.sizedTextStyle(SettingsState.menuHeight - 2),
        ),
      ),
      const Spacer(),
    ];

    for (var ico in tools) {
      items.add(ico);
    }
    return items;
  }
}
