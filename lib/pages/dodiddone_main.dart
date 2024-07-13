import 'package:flutter/material.dart'; // Импорт для форматирования даты
import 'package:zerocoderdodiddone/utils/task_dialog.dart';

import '../themes/dodiddone_theme.dart';
import '../widgets/all_tasks_widget.dart';
import '../widgets/completed_task_widget.dart';
import '../widgets/profile_widget.dart';
import '../widgets/todayTasks_widget.dart'; // Импорт модели Task

class DoDidDoneMain extends StatefulWidget {
  const DoDidDoneMain({super.key});

  @override
  State<DoDidDoneMain> createState() => _DoDidDoneMainState();
}

class _DoDidDoneMainState extends State<DoDidDoneMain> {
  int _selectedIndex = 0; // Индекс выбранного раздела

  final List<Widget> _screens = [
    // Страница "Все задачи"
    const AllTasksWidget(),

    // Страница "Задачи на сегодня"
    const TodayTasksWidget(),

    // Страница "Выполненные"
    const CompletedTasksWidget(),

    // Страница "Профиль"
    const ProfileWidget(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

// Переменная для выбранной даты

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            icon: Icon(
              Icons.list,
              size: 30,
            ),
            label: 'Все',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.today,
              size: 30,
            ),
            label: 'Сегодня',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.check_circle,
              size: 30,
            ),
            label: 'Выполненные',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 30,
            ),
            label: 'Профиль',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: DoDidDoneTheme.lightTheme.colorScheme.secondary,
        onPressed: () {
          showAddTaskDialog(context, null);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
