 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zerocoderdodiddone/models/task_model.dart';

void showAddTaskDialog(BuildContext context) {
  final _formKey = GlobalKey<FormState>(); // Ключ для формы
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dueDateController = TextEditingController();
  DateTime? _selectedDate; // Переменная для выбранной даты

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
                          _selectDate(context, _selectedDate ?? DateTime.now());
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
  Future<DateTime> _selectDate(BuildContext context, DateTime _selectedDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    return picked ?? _selectedDate;
      }
