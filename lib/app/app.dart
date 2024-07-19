import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/login_page.dart';
import '../pages/main_page.dart';
import '../services/firebase_auth.dart';
import '../theme/theme.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthenticationService _authService =
      AuthenticationService(); // Initialize your AuthService
  late User? user;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    user = _authService.currentUser;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: DoDidDoneTheme.lightTheme,
      home: user == null ? const LoginPage() : const MainPage(),
    );
  }
}
