import 'package:flutter/material.dart';

class DoDidDoneTheme {
  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
      primary: const Color(0xFF9F7BF6),
      secondary: const Color(0xFF4CEB8B),
    ),
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    primaryColor: const Color(0xFF9F7BF6), // Основной цвет
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF9F7BF6),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    timePickerTheme: TimePickerThemeData(
        confirmButtonStyle: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(Color(0xFF9F7BF6))),
        cancelButtonStyle: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(Color(0xFF9F7BF6)))),
    datePickerTheme: const DatePickerThemeData(
        confirmButtonStyle: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(Color(0xFF9F7BF6))),
        cancelButtonStyle: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(Color(0xFF9F7BF6)))),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color.fromRGBO(115, 90, 172, 1),
      selectedItemColor: Color(0xFF9F7BF6),
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: Color(0xFF9F7BF6),
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.normal,
        color: Color(0xFF9F7BF6),
      ),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFF4CEB8B),
      textTheme: ButtonTextTheme.primary,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.white),
        // backgroundColor: MaterialStateProperty.all(const Color(0xFF4CEB8B)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(const Color(0xFF4CEB8B)),
        foregroundColor: MaterialStateProperty.all(Colors.white),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.black,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    primaryColor: const Color(0xFF9F7BF6), // Основной цвет
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF9F7BF6),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: const Color(0xFF4CEB8B),
      textTheme: ButtonTextTheme.primary,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.white),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(const Color(0xFF4CEB8B)),
        foregroundColor: MaterialStateProperty.all(Colors.white),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.white,
      ),
    ),
  );
}
