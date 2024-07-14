import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zerocoderdodiddone/models/task_model.dart';
import 'package:zerocoderdodiddone/services/notifications_service.dart';

import '../services/local_notifications.dart';

void showAddTaskDialog(BuildContext context, Task? task) {
  final _formKey = GlobalKey<FormState>(); // Ключ для формы
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dueDateController = TextEditingController();
  final _importanceController = TextEditingController();
  DateTime? _selectedDate; // Переменная для выбранной даты
  bool _isImportant = false; // Переменная для чекбокса "Важно"
  var notificationService = NotificationService();

  // Заполняем поля формы, если редактируем задачу
  if (task != null) {
    _titleController.text = task.title;
    _descriptionController.text = task.description;
    _selectedDate = task.dueDate;
    _dueDateController.text = task.dueDate.toString();
    _importanceController.text = task.isImportant.toString();
    _isImportant = task.isImportant; // Заполняем чекбокс "Важно"
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        title: task != null
            ? const Text('Редактировать задачу')
            : const Text('Добавить задачу'),
        content: Form(
          key: _formKey,
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
              const SizedBox(
                height: 16,
                width: double.infinity,
              ),

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
                    onPressed: () async {
                      _selectedDate = await _selectDateTime(
                          context, _selectedDate ?? DateTime.now());
                      _dueDateController.text = _selectedDate.toString();
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
              const SizedBox(height: 16),

              // Чекбокс "Важно"
              CheckBox(
                important: _isImportant,
                onChanged: (value) {
                  _isImportant = value;
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
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue, // Синий цвет текста
            ),
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
                  isImportant: _isImportant, // Добавляем "Важно"
                );

                // Отправка задачи в Firebase
                if (task != null) {
                  // Редактирование существующей задачи
                  await FirebaseFirestore.instance
                      .collection('tasks')
                      .doc(task.id)
                      .update(newTask.toMap());
                } else {
                  // Создание новой задачи
                  final docRef =
                      FirebaseFirestore.instance.collection('tasks').doc();
                  await docRef.set(newTask.toMap());
                }

                await notificationService.init();
                if (task?.isImportant ?? false) {
                  LocalNotifications.showSimpleNotification(
                      title: "Simple Notification",
                      body: "This is a simple notification",
                      payload: "This is simple data");

                  await notificationService.showNotification(
                      id: 2, title: title, body: description);
                  await notificationService.showNotification(
                      id: 1,
                      title: title,
                      body: description,
                      scheduledDate: dueDate);
                }

                // Очистка полей формы
                _titleController.clear();
                _descriptionController.clear();
                _dueDateController.clear();
                _selectedDate = null; // Сброс выбранной даты
                _isImportant = false; // Сброс чекбокса "Важно"

                // Закрытие диалогового окна
                Navigator.of(context).pop();
              }
            },
            child:
                task != null ? const Text('Сохранить') : const Text('Добавить'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red, // Красный цвет текста
            ),
          ),
        ],
      );
    },
  );
}

class CheckBox extends StatefulWidget {
  final bool important;
  final Function onChanged;

  const CheckBox({super.key, required this.important, required this.onChanged});

  @override
  State<CheckBox> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  late bool _impotant;

  @override
  void initState() {
    super.initState();
    _impotant = widget.important;
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: const Text('Важно'),
      value: _impotant,
      onChanged: (value) {
        _impotant = value!;
        widget.onChanged(value);
        setState(() {});
      },
    );
  }
}

// Метод для выбора даты

Future<DateTime> _selectDateTime(
    BuildContext context, DateTime _selectedDateTime) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: _selectedDateTime ?? DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );

  if (picked != null) {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(picked),
    );
    if (time != null) {
      return DateTime(
        picked.year,
        picked.month,
        picked.day,
        time.hour,
        time.minute,
      );
    }
  }
  return _selectedDateTime ?? DateTime.now();
}
