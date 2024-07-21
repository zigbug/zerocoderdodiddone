import 'package:flutter/material.dart';
import '../screens/all_tasks.dart';
import '../screens/completed.dart';
import '../screens/for_today.dart';
import '../services/firebase_data_sevice.dart';
import '../theme/theme.dart';
import '../widgets/dialog_widget.dart';
import 'profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.toggleTheme});
  final Function toggleTheme;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late TaskService taskService;

  @override
  void initState() {
    taskService = TaskService();
    super.initState();
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Функция для показа диалога добавления задачи
  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String title = '';
        String description = '';
        DateTime deadline = DateTime.now();

        return DialogWidget(
          taskService: taskService,
          title: title,
          description: description,
          deadline: deadline,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      TasksPage(
        taskService: taskService,
      ),
      ForTodayPage(
        taskService: taskService,
      ),
      ComplededPage(
        taskService: taskService,
      ), // Используем ComplededPage для 3-го элемента
    ];
    final List<Widget> _titleOptions = [
      Text('Нераспределённые'),
      const Text('На сегодня'),
      Text('Завершены')
    ];
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: _titleOptions.elementAt(_selectedIndex),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProfilePage(toggleTheme: widget.toggleTheme)));
            },
            icon: const Icon(
              Icons.person_2,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Container(
        // Добавляем Container для градиента
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [
              // Используем Theme.of(context) для получения текущей темы
              Theme.of(context).brightness == Brightness.light
                  ? DoDidDoneTheme.lightTheme.colorScheme.secondary
                  : DoDidDoneTheme.darkTheme.colorScheme.secondary,
              Theme.of(context).brightness == Brightness.light
                  ? DoDidDoneTheme.lightTheme.colorScheme.primary
                  : DoDidDoneTheme.darkTheme.colorScheme.primary,
            ],
            stops: const [0.1, 0.9], // Основной цвет занимает 90%
          ),
        ),
        child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Задачи',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Сегодня',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Выполнено',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
