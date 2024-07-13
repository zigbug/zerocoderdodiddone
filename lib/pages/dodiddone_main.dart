import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Импорт Firestore
import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // Импорт для форматирования даты

import '../themes/dodiddone_theme.dart';
import '../widgets/all_tasks_widget.dart';
import '../widgets/completed_task_widget.dart';
import '../widgets/profile_widget.dart';
import '../models/task_model.dart';
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

  final _formKey = GlobalKey<FormState>(); // Ключ для формы
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dueDateController = TextEditingController();
  DateTime? _selectedDate; // Переменная для выбранной даты

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: const Text('Добавить задачу'),
          content: Form(
            key: _formKey,
            child: Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Поле "Название"
                  TextFormField(
                    controller: _titleController,
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
                  SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Суть задачи'),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Введите суть задачи';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
              
                  // Поле "Дедлайн"
                  TextFormField(
                    controller: _dueDateController,
                    decoration: InputDecoration(
                      labelText: 'Дедлайн',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () {
                          _selectDate(context);
                        },
                      ),
                    ),
                    keyboardType: TextInputType.datetime,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                    ], // Разрешаем только цифры и "/"
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
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Получение данных из полей формы
                  final title = _titleController.text;
                  final description = _descriptionController.text;
                  final dueDate = _selectedDate ??
                      DateTime.now(); // Используем выбранную дату

                  // Создание объекта Task
                  final newTask = Task(
                    // ID будет сгенерирован Firebase
                    title: title,
                    description: description,
                    dueDate: dueDate,
                    createdAt: DateTime.now(),
                    isForToday: false,
                    isCompleted: false,
                  );

                  // Отправка задачи в Firebase
                  final docRef =
                      FirebaseFirestore.instance.collection('tasks').doc();
                  await docRef.set(newTask.toMap());

                  // Очистка полей формы
                  _titleController.clear();
                  _descriptionController.clear();
                  _dueDateController.clear();
                  _selectedDate = null; // Сброс выбранной даты

                  // Закрытие диалогового окна
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Добавить'),
            ),
          ],
        );
      },
    );
  }

  // Метод для выбора даты
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dueDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

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
            icon:
                Icon(Icons.list,),
            label: 'Все',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.today,
                ),
            label: 'Сегодня',
          ),
         
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle,),
            label: 'Выполненные',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,),
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
