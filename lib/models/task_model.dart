import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task_model.g.dart';


enum Priority {
  low,
  medium,
  high,
}


@JsonSerializable()
class Task extends Equatable {
  final String? id;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;
  final DateTime createdAt; // Поле для времени создания
  final bool isForToday; // Булевое поле "на сегодня"
  final bool isImportant;

  const Task({this.isImportant=false, 
     this.id,
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

    // Метод copyWith
  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
    DateTime? createdAt,
    bool? isForToday,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      isForToday: isForToday ?? this.isForToday,
    );
  }

  Priority get priority {
      final today = DateTime.now();
    final difference = dueDate.difference(today).inDays;

    // Базовый приоритет
    Priority basePriority = difference > 2
        ? Priority.low
        : difference > 0
            ? Priority.medium
            : Priority.high;

    // Учитываем isImportant
    if (isImportant) {
      if (basePriority == Priority.low) {
        return Priority.medium;
      } else if (basePriority == Priority.medium) {
        return Priority.high;
      }
    }

    return basePriority;
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

