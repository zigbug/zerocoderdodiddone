import 'package:flutter/material.dart';
import 'package:zerocoderdodiddone/widgets/profile_widget.dart'; // Импорт сервиса

import '../services/firebase_auth_sevice.dart';
import '../themes/dodiddone_theme.dart';
import 'dodiddone_main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSignIn = true; // Флаг для определения режима (вход/регистрация)
  final _formKey = GlobalKey<FormState>(); // Ключ для формы
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthenticationService(); // Создание экземпляра сервиса

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: _isSignIn
                  ? [
                      DoDidDoneTheme.lightTheme.colorScheme.secondary,
                      DoDidDoneTheme.lightTheme.colorScheme.primary,
                    ]
                  : [
                      DoDidDoneTheme.lightTheme.colorScheme.primary,
                      DoDidDoneTheme.lightTheme.colorScheme.secondary,
                    ],
              stops: const [0.05, 0.8], // Основной цвет занимает 80%
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Image.asset(
                      'assets/0qode_symbol_1.png', // Путь к картинке
                      height: 50, // Высота картинки
                      width: 50, // Ширина картинки
                    ),
                    const SizedBox(width: 5),
                    // Белая надпись "zerocoder"
                    Text(
                      'zerocoder',
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ]),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 46,
                          fontWeight: FontWeight.normal,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Do',
                              style: TextStyle(color: Colors.white)),
                          TextSpan(
                              text: 'Did',
                              style: TextStyle(
                                  color: DoDidDoneTheme
                                      .lightTheme.colorScheme.primary)),
                          TextSpan(
                              text: 'Done',
                              style: TextStyle(
                                  color: DoDidDoneTheme
                                      .lightTheme.colorScheme.secondary)),
                        ],
                      ),
                    ),
                  ),

                  // Заголовок

                  const SizedBox(height: 15),
                  Text(
                    _isSignIn ? 'Вход' : 'Регистрация',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (_isSignIn) const SizedBox(height: 50),

                  // Поле логина/почты
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Почта',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите email';
                      }
                      if (!value.contains('@')) {
                        return 'Неверный формат email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Поле пароля
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Пароль',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите пароль';
                      }
                      return null;
                    },
                  ),
                  if (!_isSignIn) const SizedBox(height: 20),
                  if (!_isSignIn)
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Подтверждение пароля',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Пожалуйста, подтвердите пароль';
                        }
                        if (value != _passwordController.text) {
                          return 'Пароли не совпадают';
                        }
                        return null;
                      },
                    ),
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isSignIn = !_isSignIn;
                      });
                    },
                    child: Text(
                      _isSignIn
                          ? 'У меня ещё нет аккаунта...'
                          : 'У меня уже есть аккаунт...',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Кнопка "Войти" / "Зарегистрироваться"
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (_isSignIn) {
                          // Вход
                          try {
                            await _authService.signInWithEmailAndPassword(
                                _emailController.text,
                                _passwordController.text);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const DoDidDoneMain()),
                            );
                          } catch (e) {
                            // Обработка ошибки входа
                            print('Ошибка входа: ${e.toString()}');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Ошибка входа: ${e.toString()}')),
                            );
                          }
                        } else {
                          // Регистрация
                          try {
                            await _authService.signUpWithEmailAndPassword(
                                _emailController.text,
                                _passwordController.text);
                            // Отправка письма с подтверждением
                            await _authService.sendEmailVerification(
                                _authService.currentUser!);
                            // Переход на страницу подтверждения
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ProfileWidget()),
                            );
                          } catch (e) {
                            // Обработка ошибки регистрации
                            print('Ошибка регистрации: ${e.toString()}');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Ошибка регистрации: ${e.toString()}')),
                            );
                          }
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isSignIn
                          ? DoDidDoneTheme.lightTheme.colorScheme.secondary
                          : DoDidDoneTheme.lightTheme.colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(_isSignIn ? 'Войти' : 'Зарегистрироваться'),
                  ),
                  const SizedBox(height: 20),

                  // Кнопка "У меня ещё нет аккаунта" / "У меня уже есть аккаунт"
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
