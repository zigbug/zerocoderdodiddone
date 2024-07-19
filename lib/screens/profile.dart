import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Импортируем Firebase Authentication

import '../pages/login_page.dart';
import '../services/firebase_auth.dart'; // Импортируем AuthenticationService

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _authenticationService =
      AuthenticationService(); // Экземпляр AuthenticationService

  @override
  Widget build(BuildContext context) {
    final user =
        _authenticationService.currentUser; // Получаем текущего пользователя

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Аватар
          CircleAvatar(
            radius: 50,
            backgroundImage: user?.photoURL != null
                ? NetworkImage(user!
                    .photoURL!) // Используем аватар пользователя, если он есть
                : const AssetImage(
                    'assets/_1.png'), // Иначе используем стандартный аватар
          ),
          const SizedBox(height: 20),

          // Почта
          Text(
            user?.email ??
                'example@email.com', // Отображаем почту пользователя, если она есть
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),

          // Кнопка подтверждения почты (отображается, если почта не подтверждена)
          if (user != null && !user.emailVerified)
            ElevatedButton(
              onPressed: () async {
                // Отправка запроса подтверждения почты
                await _authenticationService.sendEmailVerification();
                // Показываем диалог с сообщением о том, что письмо отправлено
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Подтверждение почты'),
                    content: const Text(
                        'Письмо с подтверждением отправлено на ваш адрес.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage())),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Подтвердить почту'),
            ),
          const SizedBox(height: 20),

          // Кнопка выхода из профиля
          ElevatedButton(
            onPressed: () async {
              // Выход из системы
              await _authenticationService.signOut();
              // Переход на страницу входа
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Красный цвет для кнопки выхода
            ),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );
  }
}



// import 'package:flutter/material.dart';

// import '../pages/login_page.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({Key? key}) : super(key: key);

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   bool isEmailVerified = false; // Флаг для проверки подтверждения почты

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Аватар
//           CircleAvatar(
//             radius: 50,
//             backgroundImage: const AssetImage(
//                 'assets/_1.png'), // Замените на реальный путь к аватару
//           ),
//           const SizedBox(height: 20),

//           // Почта
//           Text(
//             'example@email.com', // Замените на реальную почту пользователя
//             style: const TextStyle(fontSize: 18),
//           ),
//           const SizedBox(height: 10),

//           // Кнопка подтверждения почты (отображается, если почта не подтверждена)
//           if (!isEmailVerified)
//             ElevatedButton(
//               onPressed: () {
//                 // Обработка отправки запроса подтверждения почты
//                 // Например, можно показать диалог с сообщением о том, что письмо отправлено
//                 showDialog(
//                   context: context,
//                   builder: (context) => AlertDialog(
//                     title: const Text('Подтверждение почты'),
//                     content: const Text(
//                         'Письмо с подтверждением отправлено на ваш адрес.'),
//                     actions: [
//                       TextButton(
//                         onPressed: () => Navigator.pop(context),
//                         child: const Text('OK'),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//               child: const Text('Подтвердить почту'),
//             ),
//           const SizedBox(height: 20),

//           // Кнопка выхода из профиля
//           ElevatedButton(
//             onPressed: () {
//               // Обработка выхода из профиля
//               // Например, можно перейти на страницу входа
//               Navigator.pushReplacement(context,
//                   MaterialPageRoute(builder: (context) {
//                 return const LoginPage();
//               }));
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red, // Красный цвет для кнопки выхода
//             ),
//             child: const Text('Выйти'),
//           ),
//         ],
//       ),
//     );
//   }
// }
