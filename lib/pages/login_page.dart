import 'package:flutter/material.dart';
import 'package:zerocoderdodiddone/pages/profile_page.dart';
import 'package:zerocoderdodiddone/services/firebase_auth.dart'; // Импортируем AuthenticationService

import '../theme/theme.dart';
import 'main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.toggleTheme});
  final Function toggleTheme;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = true; // Флаг для определения режима (вход/регистрация)
  final _formKey = GlobalKey<FormState>(); // Ключ для формы
  final _emailController = TextEditingController(); // Контроллер для поля email
  final _passwordController =
      TextEditingController(); // Контроллер для поля пароля
  final _confirmPasswordController =
      TextEditingController(); // Контроллер для поля подтверждения пароля
  final _authenticationService =
      AuthenticationService(); // Экземпляр AuthenticationService

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
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: isLogin
                ? [
                    DoDidDoneTheme.lightTheme.colorScheme.secondary,
                    DoDidDoneTheme.lightTheme.colorScheme.primary,
                  ]
                : [
                    DoDidDoneTheme.lightTheme.colorScheme.primary,
                    DoDidDoneTheme.lightTheme.colorScheme.secondary,
                  ],
            stops: const [0.1, 0.9], // Основной цвет занимает 90%
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey, // Добавляем ключ для формы
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/0qode_symbol_1.png', // Замените на правильный путь к файлу
                        height: 60, // Устанавливаем высоту изображения
                      ),
                      const SizedBox(width: 8),
                      // Добавляем текст "zerocoder"
                      const Text(
                        'zerocoder',
                        style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Белый цвет текста
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Добавляем текст "Do"
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: 'Do',
                        style: TextStyle(
                          color: DoDidDoneTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                      const TextSpan(
                        text: 'Did',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextSpan(
                        text: 'Done',
                        style: TextStyle(
                          color:
                              DoDidDoneTheme.lightTheme.colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Заголовок
                Text(
                  isLogin ? 'Вход' : 'Регистрация',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller:
                      _emailController, // Используем контроллер для поля email
                  decoration: const InputDecoration(
                    hintText: 'Почта',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
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
                  controller:
                      _passwordController, // Используем контроллер для поля пароля
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Пароль',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
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
                const SizedBox(height: 20),

                // **Новое поле "Повторить пароль"**
                if (!isLogin) // Отображаем только при регистрации
                  TextFormField(
                    controller:
                        _confirmPasswordController, // Используем контроллер для поля подтверждения пароля
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Повторить пароль',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, повторите пароль';
                      }
                      if (value != _passwordController.text) {
                        return 'Пароли не совпадают';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 30),

                // Кнопка "Войти"
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Проверяем, валидна ли форма
                      if (isLogin) {
                        // Вход в систему
                        try {
                          final userCredential = await _authenticationService
                              .signInWithEmailAndPassword(_emailController.text,
                                  _passwordController.text);
                          if (userCredential != null &&
                              userCredential.user?.emailVerified == true) {
                            // Переход на MainPage
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainPage(
                                        toggleTheme: widget.toggleTheme)));
                          } else if (userCredential != null) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfilePage(
                                        toggleTheme: widget.toggleTheme)));
                          }
                        } catch (e) {
                          // Вывод сообщения об ошибке пользователю
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Ошибка входа: $e')));
                        }
                      } else {
                        // Регистрация
                        try {
                          final userCredential = await _authenticationService
                              .createUserWithEmailAndPassword(
                                  _emailController.text,
                                  _passwordController.text);
                          if (userCredential != null) {
                            // Переход на ProfilePage
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfilePage(
                                          toggleTheme: widget.toggleTheme,
                                        )));
                          }
                        } catch (e) {
                          // Вывод сообщения об ошибке пользователю
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Ошибка регистрации: $e')));
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !isLogin
                        ? DoDidDoneTheme.lightTheme.colorScheme.primary
                        : DoDidDoneTheme.lightTheme.colorScheme.secondary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(isLogin ? 'Войти' : 'Зарегистрироваться'),
                ),
                const SizedBox(height: 20),

                // Кнопка перехода на другую страницу
                TextButton(
                  onPressed: () {
                    setState(() {
                      isLogin = !isLogin;
                    });
                  },
                  child: Text(
                    isLogin
                        ? 'У меня ещё нет аккаунта...'
                        : 'Уже есть аккаунт...',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
