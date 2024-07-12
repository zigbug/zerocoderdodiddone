import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../themes/dodiddone_theme.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileWidget> {
  User? _user;
  bool _isEmailVerified = false;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      _isEmailVerified = _user!.emailVerified;
    }
    setState(() {});
  }

  Future<void> _sendEmailVerification() async {
    if (_user != null && !_isEmailVerified) {
      try {
        await _user!.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Письмо с подтверждением отправлено!')),
        );
      } on Exception catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка отправки письма: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            DoDidDoneTheme.lightTheme.colorScheme.secondary,
            DoDidDoneTheme.lightTheme.colorScheme.primary,
          ],
          stops: const [0.05, 0.8], // Основной цвет занимает 80%
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Фото профиля (если доступно)
            // CircleAvatar(
            //   radius: 50,
            //   backgroundImage: NetworkImage(
            //       'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50?s=200&d=mm&r=g'), // Замените на реальный URL
            // ),
            const SizedBox(height: 20),

            // Имя пользователя
            Text(
              '${_user?.displayName ?? 'Имя пользователя'}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),

            // Email
            Text(
              '${_user?.email ?? 'Email не указан'}',
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 10),

            // Сообщение о валидации
            if (!_isEmailVerified)
              Text(
                'Почта не подтверждена. Проверьте почту.',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),

            // Кнопка запроса валидации
            if (!_isEmailVerified)
              ElevatedButton(
                onPressed: _sendEmailVerification,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      DoDidDoneTheme.lightTheme.colorScheme.secondary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Отправить подтверждение'),
              ),
            const SizedBox(height: 20),

            // Кнопка выхода
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                // Переход на страницу входа
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    DoDidDoneTheme.lightTheme.colorScheme.secondary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Выйти'),
            ),
          ],
        ),
      ),
    );
  }
}
