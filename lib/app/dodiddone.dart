import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zerocoderdodiddone/pages/login_page.dart';
import 'package:zerocoderdodiddone/themes/dodiddone_theme.dart';

import '../pages/dodiddone_main.dart';
import '../services/firebase_auth_sevice.dart'; // Import your AuthService

class DoDidDoneApp extends StatefulWidget {
  const DoDidDoneApp({super.key});

  @override
  State<DoDidDoneApp> createState() => _DoDidDoneAppState();
}

class _DoDidDoneAppState extends State<DoDidDoneApp> {
  final AuthenticationService _authService = AuthenticationService(); // Initialize your AuthService
late User? user;

  @override
  void initState() {
    super.initState();
    _authService.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DoDidDone',
      theme: DoDidDoneTheme.lightTheme,
      home: _authService.currentUser != null
          ? const DoDidDoneMain() // Navigate to DoDidDoneMain if authenticated
          : const LoginPage(), // Navigate to LoginPage if not authenticated
    );
  }
}
