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

class Palette {
  static const background = Color(0xFF131313);
  static const backgroundLight = Color(0xFF333333);

  static const controlBackground = Color.fromARGB(255, 37, 37, 37);

  static const tankBorder = Color(0xFF2E2E2E);
  static const tankBackground = Color(0xFF282828);
  static const water = Color(0xFF3D3483);
  static const socketColor = Color.fromARGB(255, 165, 146, 146);

  static const darkGrey = Color(0xFF181818);
  static const darkGrey1 = Color(0xFF2A2A2F);
  static const darkGrey2 = Color(0xFF222222);
  static const highlight = Color(0xFF9F9FAF);

  static const highlightTransparent = Color(0xFF9F9FAF);
  static const wireLight = Color(0xFF6A6A9F);
  static const wireTitle = Color(0xFF5A5A7F);
  static const wire = Color(0xFF4F4F69);
  static const wireShadow = Color(0xFF30303F);
  static const action = Color(0xFFE94545);
  static const actionLight = Color.fromARGB(255, 249, 114, 114);
  static const actionSecondary = Color(0xFF45E945);
  static const actionSecondaryLight = Color.fromARGB(255, 114, 246, 114);
  static const transparent = Color(0x00E94545);

  static const titleText = Color(0xFF9F9B9B);
  static const titleIcon = Color(0xFFA5A1A0);
  static const titleBackground = Color(0xFF131313);
  static const titleForeground = titleText;

  static const subTitleBackground = backgroundLight;

  static const wireNoChange = Color(0xFF585357);
  static const wireChange = Color(0xFF716B71);

  static const editTextForeground = Color(0xFFB1A294);
  static const editTextBackground = Color(0xFF323030);
  static const editTextWidgetBackground = Color(0xFF252525);
  static const editTextWidgetInnerBorder = Color(0xFF201E1F);
  static const editTextWidgetBorder = Color(0xFFE6E6E6);
  static const editTextButtonBackground = Color(0xFF1E1E1E);
  static const editTextButtonForeground = Color(0xFF9F9B9B);

  static const settingsBackground = Color(0xFF1C1C1C);
  static const settingsForeground = Color(0xFFBEBEBE);
  static const settingsForeground1 = Color(0xFF787878);
  static const settingsForeground2 = Color(0xFFBEB6B6);
  static const settingsAccent = Color(0xFFFFFFFF);

  static const boxBackground = Color(0xFF1E1E1E);
  static const pinBackground = Color(0xFF383439);
  static const pinBorder = Color(0xFF383439);

  static const toolTipForeground = Color(0xFFFFFFFF);
  static const toolTipBackground = Color(0x401E1E1E);

  static const memoryAction = Color(0xFFE94545);
  static const memoryHighlight = Color(0xFFBDB7B9);
  static const memoryTextMiddle = Color(0xFF716E71);
  static const memoryText = Color(0xFF575758);
  static const memorySelection = Color(0xFF323234);
  static const memorySelectionHighlight = Color(0x26646465);
  static const memorySelectionBorder = Color(0x80505058);

  static const empty = Color.fromARGB(255, 255, 0, 255);

  static const Color colorSchemeSeed = Color(0x00FF0090);
  static const Brightness brightness = Brightness.dark;
  static const MaterialColor primarySwatch = Colors.amber;
  static const Color primaryColor = Palette.empty;
  static const Color primaryColorLight = Palette.empty;
  static const Color primaryColorDark = Palette.empty;
  static const Color focusColor = Palette.empty;
  static const Color hoverColor = Palette.empty;
  static const Color shadowColor = Palette.empty;
  static const Color canvasColor = controlBackground;
  static const Color scaffoldBackgroundColor = Palette.controlBackground;
  static const Color bottomAppBarColor = Palette.empty;
  static const Color cardColor = Palette.empty;
  static const Color dividerColor = Palette.empty;
  static const Color highlightColor = Palette.empty;
  static const Color splashColor = Palette.empty;
  static const Color selectedRowColor = Palette.empty;
  static const Color unselectedWidgetColor = Palette.empty;
  static const Color disabledColor = Palette.empty;
  static const Color secondaryHeaderColor = Palette.empty;
  static const Color backgroundColor = Palette.background;
  static const Color dialogBackgroundColor = Palette.background;
  static const Color indicatorColor = Palette.empty;
  static const Color hintColor = Palette.empty;
  static const Color errorColor = Palette.empty;
  static const Color toggleableActiveColor = Palette.empty;

  static const programTheme = {
    'root': TextStyle(
      backgroundColor: Palette.canvasColor,
      color: Color(0xFFDDDDDD),
      fontWeight: FontWeight.w500,
    ),
    'keyword': TextStyle(
      color: Palette.empty,
      fontWeight: FontWeight.bold,
    ),
    'selector-tag': TextStyle(
      color: Palette.empty,
      fontWeight: FontWeight.bold,
    ),
    'literal': TextStyle(
      color: Palette.empty,
      fontWeight: FontWeight.bold,
    ),
    'section': TextStyle(
      color: Color(0xffffffff),
      fontWeight: FontWeight.bold,
    ),
    'link': TextStyle(color: Color(0xffffffff)),
    'subst': TextStyle(color: Color(0xffffffff)),
    'string': TextStyle(
      color: Color(0xFFF5A180),
      fontWeight: FontWeight.w500,
    ),
    'title': TextStyle(
      color: Palette.empty,
      fontWeight: FontWeight.bold,
    ),
    'name': TextStyle(
      color: Color(0xFF59AFF4),
      fontWeight: FontWeight.w800,
    ),
    'type': TextStyle(
      color: Color(0xFF59AFF4),
      fontWeight: FontWeight.w800,
    ),
    'attribute': TextStyle(
      color: Color(0xFF59AFF4),
      fontWeight: FontWeight.w600,
    ),
    'symbol': TextStyle(color: Color(0xff569cd6)),
    'bullet': TextStyle(color: Color(0xffdd8888)),
    'built_in': TextStyle(color: Color(0xffdd8888)),
    'addition': TextStyle(color: Color(0xffdd8888)),
    'variable': TextStyle(color: Color(0xffdd8888)),
    'template-tag': TextStyle(color: Color(0xffdd8888)),
    'template-variable': TextStyle(color: Color(0xffdd8888)),
    'comment': TextStyle(
      color: Color.fromARGB(255, 126, 192, 96),
      fontWeight: FontWeight.w500,
    ),
    'quote': TextStyle(color: Color.fromARGB(255, 255, 0, 255)),
    'deletion': TextStyle(color: Color.fromARGB(255, 255, 0, 255)),
    'meta': TextStyle(color: Color.fromARGB(255, 255, 0, 255)),
    'doctag': TextStyle(fontWeight: FontWeight.bold),
    'strong': TextStyle(fontWeight: FontWeight.bold),
    'emphasis': TextStyle(fontStyle: FontStyle.italic),
  };
}
