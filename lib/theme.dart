

import 'package:flutter/material.dart';
import 'package:waterpark/palette.dart';

class WorkspaceTheme
{
  static const TextStyle labelTextStyle = TextStyle(
    fontSize: 20,
    color: Palette.highlight,
  );


  static TextButtonThemeData textButtonTheme = TextButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStateProperty.all(labelTextStyle),
      foregroundColor: MaterialStateProperty.all(Palette.highlight),
      backgroundColor: MaterialStateProperty.all(Palette.transparent),
    )
  );
}