import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../pages/login_page.dart';
import '../services/firebase_auth.dart';
import '../utils/image_picer_util.dart'; // Импортируем ImagePickerUtil

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authenticationService =
      AuthenticationService(); // Экземпляр AuthenticationService
  File? _selectedImage; // Переменная для хранения выбранного изображения
  bool _showSaveButton = false; // Флаг для отображения кнопки "Сохранить"

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
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: _selectedImage != null
                    ? FileImage(
                        _selectedImage!) // Используем выбранное изображение, если оно есть
                    : user?.photoURL != null
                        ? NetworkImage(user!
                            .photoURL!) // Используем аватар пользователя, если он есть
                        : const AssetImage(
                            'assets/_1.png'), // Иначе используем стандартный аватар
              ),
              Positioned(
                  bottom: -16,
                  right: -14,
                  child: IconButton(
                      onPressed: () {
                        // Показываем диалог выбора изображения
                        _showImagePickerDialog(context);
                      },
                      icon: Icon(Icons.photo_camera)))
            ],
          ),

          // Кнопка "Сохранить" (отображается, если выбрано новое изображение)
          if (_showSaveButton)
            ElevatedButton(
              onPressed: () async {
                // Загрузка изображения в Firebase Storage
                if (_selectedImage != null) {
                  try {
                    final storageRef = firebase_storage.FirebaseStorage.instance
                        .ref()
                        .child('user_avatars/${user!.uid}');
                    // final uploadTask =
                    await storageRef.putFile(_selectedImage!);
                    // await uploadTask.whenComplete(() async {
                    // Получение URL-адреса загруженного изображения
                    final downloadURL = await storageRef.getDownloadURL();
                    // Обновление URL-адреса аватара пользователя в Firebase Authentication
                    await user.updatePhotoURL(downloadURL);
                    print('object downloadURL');
                    // Сброс состояния

                    setState(() {
                      _selectedImage = null;
                      _showSaveButton = false;
                    });
                    // Вывод сообщения об успешном сохранении
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Аватар сохранен')));
                    // }
                    // );
                  } catch (e) {
                    // Обработка ошибок при загрузке
                    print('Ошибка загрузки аватара: $e');
                    // Вывод сообщения об ошибке пользователю
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ошибка загрузки: $e')));
                  }
                }
              },
              child: const Text('Сохранить'),
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

  // Диалог выбора изображения
  void _showImagePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Выберите изображение'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Из галереи'),
                onTap: () async {
                  // Выбор изображения из галереи
                  File? imageFile =
                      await ImagePickerUtil.pickImageFromGallery();
                  if (imageFile != null) {
                    setState(() {
                      _selectedImage = imageFile;
                      _showSaveButton = true; // Показываем кнопку "Сохранить"
                    });
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Сделать снимок'),
                onTap: () async {
                  // Съемка изображения с камеры
                  File? imageFile = await ImagePickerUtil.pickImageFromCamera();
                  if (imageFile != null) {
                    setState(() {
                      _selectedImage = imageFile;
                      _showSaveButton = true; // Показываем кнопку "Сохранить"
                    });
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
