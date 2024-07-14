import 'package:flutter/material.dart'; // Импорт для форматирования даты
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:zerocoderdodiddone/utils/task_dialog.dart';

import '../services/local_notifications.dart';
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
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  listenToNotifications() {
    print("Listening to notification");
    LocalNotifications.onClickNotification.stream.listen((event) {
      print(event);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const DoDidDoneMain()));
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    ininializeLocalNotifications();
    listenToNotifications();
    super.initState();
  }

  void ininializeLocalNotifications() async {
    await LocalNotifications.init();
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
        title: Row(children: [
          Image.asset(
            'assets/0qode_symbol_1.png', // Путь к картинке
            height: 25, // Высота картинки
            width: 25, // Ширина картинки
          ),
          const SizedBox(width: 5),
          // Белая надпись "zerocoder"
          Text(
            'zerocoder',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ]),
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
