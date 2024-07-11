import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../themes/dodiddone_theme.dart';
import 'profile_page.dart';

class DoDidDoneMain extends StatefulWidget {
  const DoDidDoneMain({super.key});

  @override
  State<DoDidDoneMain> createState() => _DoDidDoneMainState();
}

class _DoDidDoneMainState extends State<DoDidDoneMain> {
  int _selectedIndex = 0; // Индекс выбранного раздела

  final List<Widget> _screens = [
    // Страница "Задачи на сегодня"
    const Center(child: Text('Задачи на сегодня')),
    // Страница "Все задачи"
    const Center(child: Text('Все задачи')),
    // Страница "Выполненные"
    const Center(child: Text('Выполненные')),
    // Страница "Профиль"
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Добавить задачу'),
          content: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Поле "Название"
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Название'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите название задачи';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Поле "Суть задачи"
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Суть задачи'),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите суть задачи';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Поле "Дедлайн"
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Дедлайн'),
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите дедлайн';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                // Обработка добавления задачи
                Navigator.of(context).pop();
              },
              child: const Text('Добавить'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 2,
        title: const Text('DoDidDone'),
      ),
      body: Container(
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
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: 'Сегодня',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Все',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Выполненные',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
