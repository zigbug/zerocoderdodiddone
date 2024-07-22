import 'package:flutter/material.dart';

class DoDidDoneTheme {
  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF9f7bf6), // Primary color
      brightness: Brightness.light,
      primary: const Color(0xFF9f7bf6), // Primary color
      secondary: const Color(0xFF4ceb8b), // Secondary color
    ),
    useMaterial3: true,
//Стиль аппбар
    appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(color: Colors.white), // Цвет иконки,
        backgroundColor: Colors.transparent, // Прозрачный AppBar
        elevation: 0, // Убираем тень
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 24)),

    // Добавляем стиль для кнопок
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          const Color(0xFF4ceb8b), // Цвет фона кнопок
        ),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        textStyle: MaterialStateProperty.all<TextStyle>(
          const TextStyle(color: Colors.white), // Текст кнопок белый
        ),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: const Color(0xFF9f7bf6), // Цвет выбранной иконки
      unselectedItemColor:
          const Color(0xFF4ceb8b).withOpacity(0.5), // Цвет невыбранной иконки
      // backgroundColor: Colors.transparent, // Прозрачный фон
      // Убираем тень
    ),
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color.fromARGB(255, 5, 5, 5), // Primary color
      brightness: Brightness.dark,
      primary: Color.fromARGB(255, 60, 30, 129), // Primary color
      secondary: Color.fromARGB(255, 26, 143, 73), // Secondary color
    ),
    useMaterial3: true,
    // Стиль аппбар
    appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(color: Colors.white), // Цвет иконки,
        backgroundColor: Colors.transparent, // Прозрачный AppBar
        elevation: 0, // Убираем тень
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 24)),

    // Добавляем стиль для кнопок
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          Color.fromARGB(255, 29, 87, 52), // Цвет фона кнопок
        ),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        textStyle: MaterialStateProperty.all<TextStyle>(
          const TextStyle(color: Colors.white), // Текст кнопок белый
        ),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.black54,
      selectedItemColor: const Color(0xFF9f7bf6), // Цвет выбранной иконки
      unselectedItemColor:
          const Color(0xFF4ceb8b).withOpacity(0.5), // Цвет невыбранной иконки
      // backgroundColor: Colors.transparent, // Прозрачный фон
      // Убираем тень
    ),
  );
}
