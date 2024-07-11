import 'package:flutter/material.dart';

import '../pages/login_page.dart';
import '../themes/dodiddone_theme.dart';

class DoDidDoneApp extends StatelessWidget {
  const DoDidDoneApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: DoDidDoneTheme.lightTheme, // Светлая тема
      darkTheme: DoDidDoneTheme.darkTheme, // Темная тема
      home: const LoginPage(),
    );
  }
}
