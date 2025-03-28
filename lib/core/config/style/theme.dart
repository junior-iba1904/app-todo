import 'package:flutter/material.dart';

const ColorGreenLightGeneral = Color.fromARGB(255, 31, 237, 64);
const ColorGreenDarkGeneral = Color.fromARGB(255, 31, 237, 111);

ThemeData light = ThemeData(
  canvasColor: Colors.black,
  hoverColor: Colors.grey,
  brightness: Brightness.light,
  primaryColor: ColorGreenLightGeneral,
  scaffoldBackgroundColor: Colors.white,
  indicatorColor: Colors.white,
  appBarTheme: const AppBarTheme(
    color: ColorGreenLightGeneral,
    titleTextStyle: TextStyle(color: Colors.black, fontSize: 25),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  floatingActionButtonTheme:
      const FloatingActionButtonThemeData(backgroundColor: ColorGreenLightGeneral),
  listTileTheme: const ListTileThemeData(
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.bold
    ),
    subtitleTextStyle: TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold
    ),
    tileColor: Colors.white
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(ColorGreenLightGeneral))
    ),

  switchTheme: SwitchThemeData(
    trackColor: WidgetStatePropertyAll(Colors.white),
    thumbColor: WidgetStatePropertyAll(Colors.blue)
  )
);

ThemeData dark = ThemeData(
  canvasColor: Colors.white,
  hoverColor: Colors.white,
  brightness: Brightness.dark,
  primaryColor: ColorGreenDarkGeneral,
  scaffoldBackgroundColor: Colors.black,
  indicatorColor: Colors.black,
  appBarTheme: const AppBarTheme(
    color: ColorGreenDarkGeneral,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(color: Colors.black, fontSize: 25),
  ),
  floatingActionButtonTheme:
      const FloatingActionButtonThemeData(backgroundColor: ColorGreenDarkGeneral),
  listTileTheme: const ListTileThemeData(
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold
    ),
    subtitleTextStyle: TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold
    ),
    tileColor: Colors.black
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(ColorGreenDarkGeneral))),
  switchTheme: SwitchThemeData(
    trackColor: WidgetStatePropertyAll(Colors.black),
    thumbColor: WidgetStatePropertyAll(Colors.blue)
  )
);
