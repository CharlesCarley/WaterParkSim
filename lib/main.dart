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
import 'package:waterpark_frontend/icon.dart';
import 'package:waterpark_frontend/palette.dart';
import 'workspace.dart';

void main() {
  runApp(const WaterPark());
}

class WaterPark extends StatelessWidget {
  const WaterPark({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WaterPark Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Palette.background),

        canvasColor: Palette.canvasColor,
        // colorSchemeSeed: Palette.colorSchemeSeed,
        // primaryColor: Palette.primaryColor,
        // primaryColorLight: Palette.primaryColorLight,
        // primaryColorDark: Palette.primaryColorDark,
        // focusColor: Palette.focusColor,
        // hoverColor: Palette.hoverColor,
        // shadowColor: Palette.shadowColor,
        // canvasColor: Palette.canvasColor,
        // scaffoldBackgroundColor: Palette.scaffoldBackgroundColor,
        // bottomAppBarColor: Palette.bottomAppBarColor,
        // cardColor: Palette.cardColor,
        // dividerColor: Palette.dividerColor,
        // highlightColor: Palette.highlightColor,
        // splashColor: Palette.splashColor,
        // selectedRowColor: Palette.selectedRowColor,
        // unselectedWidgetColor: Palette.unselectedWidgetColor,
        // disabledColor: Palette.disabledColor,
        // secondaryHeaderColor: Palette.secondaryHeaderColor,
        // backgroundColor: Palette.backgroundColor,
        // dialogBackgroundColor: Palette.dialogBackgroundColor,
        // indicatorColor: Palette.indicatorColor,
        // hintColor: Palette.hintColor,
        // errorColor: Palette.errorColor,
        // toggleableActiveColor: Palette.toggleableActiveColor,
      ),
      home: Scaffold(
        appBar: AppBar(
          foregroundColor: Palette.titleForeground,
          backgroundColor: Palette.titleBackground,
          title: Text("WaterPark"),
          actions: [
            // IconWidget(
            //   icon: IconMappings.play,
            //   x: 0,
            //   y: 0,
            //   color: Palette.titleForeground,
            //   onClick: (){},
            //   tooltip: "",
            // )
          ],
        ),
        body: WorkSpaceWidget(),
      ),
    );
  }
}
