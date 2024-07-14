import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zerocoderdodiddone/utils/task_dialog.dart';

import '../models/task_model.dart';

enum Screen { allTasks, forToday, completed }

class TaskItem extends StatelessWidget {
  final Task task;
  final Screen screen;
  final void Function(bool?) onChanged;
  final void Function() onDismissedLeft;
  final void Function() onDismissedRight;
  final void Function() onEdit; // Добавляем функцию onEdit
  final void Function() onDelete; // Добавляем функцию onDelete
  final List<Widget> icons = const [
    Icon(Icons.calendar_today, color: Colors.white),
    Icon(Icons.check_circle, color: Colors.white),
    Icon(Icons.list, color: Colors.white),
  ];

  const TaskItem({
    super.key,
    required this.screen,
    required this.task,
    required this.onChanged,
    required this.onDismissedLeft,
    required this.onDismissedRight,
    required this.onEdit, // Передаем функцию onEdit
    required this.onDelete, // Передаем функцию onDelete
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.createdAt.toString()),
      //смещение слева направо
      background: Container(
        color: Colors.blue,
        child: Align(
          alignment: Alignment.centerLeft,
          child: icons[screen.index],
        ),
      ),
      secondaryBackground: Container(
        color: Colors.green,
        child: Align(
          alignment: Alignment.centerRight,
          child: icons[(screen.index + 1) % icons.length],
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          onDismissedLeft();
        } else if (direction == DismissDirection.endToStart) {
          onDismissedRight();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Верхняя часть с градиентом и заголовком
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  gradient: getGradient(task.priority),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Изменили цвет на черный
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Основная часть информации
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Крайний срок
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                                'Крайний срок:  ${DateFormat('dd.MM.yy в HH:mm').format(task.dueDate)}'),
                          ),
                          const SizedBox(height: 8),

                          // Описание
                          Text(task.description),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {
                              showAddTaskDialog(context, task);
                            }, // Вызываем функцию диалог при нажатии
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed:
                                onDelete, // Вызываем функцию onDelete при нажатии
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Функция для получения градиента в зависимости от приоритета
  LinearGradient getGradient(Priority priority) {
    switch (priority) {
      case Priority.high:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.red, Colors.white],
        );
      case Priority.medium:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.yellow, Colors.white],
        );
      case Priority.low:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.green, Colors.white],
        );
    }
  }
}
