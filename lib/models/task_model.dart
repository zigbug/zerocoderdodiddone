import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';

part 'task_model.g.dart';

@JsonSerializable()
class Task extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;
  final DateTime createdAt; // Поле для времени создания
  final bool isForToday; // Булевое поле "на сегодня"

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
    required this.createdAt, // Инициализация времени создания
    this.isForToday = false, // Инициализация поля "на сегодня"
  });

  // Метод для обновления статуса задачи
  Task toggleCompleted() {
    return Task(
      id: id,
      title: title,
      description: description,
      dueDate: dueDate,
      isCompleted: !isCompleted,
      createdAt: createdAt,
      isForToday: isForToday,
    );
  }

  // Метод для обновления статуса "на сегодня"
  Task toggleForToday() {
    return Task(
      id: id,
      title: title,
      description: description,
      dueDate: dueDate,
      isCompleted: isCompleted,
      createdAt: createdAt,
      isForToday: !isForToday,
    );
  }

  // Метод для создания новой задачи из Map
  factory Task.fromMap(Map<String, dynamic> data) {
    return Task(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      dueDate: DateTime.parse(data['dueDate']),
      isCompleted: data['isCompleted'] ?? false,
      createdAt: DateTime.parse(data['createdAt']), // Парсинг времени создания
      isForToday: data['isForToday'] ?? false, // Парсинг поля "на сегодня"
    );
  }

  // Метод для преобразования задачи в Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted,
      'createdAt': createdAt
          .toIso8601String(), // Преобразование времени создания в строку
      'isForToday': isForToday, // Добавление поля "на сегодня" в Map
    };
  }

  // Реализация Equatable
  @override
  List<Object?> get props =>
      [id, title, description, dueDate, isCompleted, createdAt, isForToday];

  // Метод fromJson
  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  // Метод toJson
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}

// Виджет для отображения задачи
class TaskWidget extends StatelessWidget {
  final Task task;
  final Function(Task) onDismissedLeft;
  final Function(Task) onDismissedRight;

  const TaskWidget({
    Key? key,
    required this.task,
    required this.onDismissedLeft,
    required this.onDismissedRight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      background: Container(
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Icon(Icons.calendar_today, color: Colors.white),
        ),
      ),
      secondaryBackground: Container(
        color: Colors.green,
        child: const Align(
          alignment: Alignment.centerRight,
          child: Icon(Icons.check_circle, color: Colors.white),
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          onDismissedLeft(task);
        } else if (direction == DismissDirection.endToStart) {
          onDismissedRight(task);
        }
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок
              Text(
                task.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Описание
              Text(task.description),
              const SizedBox(height: 8),

              // Крайний срок
              Text('Крайний срок: ${task.dueDate}'),
              const SizedBox(height: 8),

              // Статус
              Checkbox(
                value: task.isCompleted,
                onChanged: (value) {
                  // Обновление статуса задачи в Firebase
                  // ...
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
