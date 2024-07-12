import 'package:flutter/material.dart';

import '../models/task_model.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final void Function(bool?) onChanged;
  final void Function() onDismissedLeft;
  final void Function() onDismissedRight;

  const TaskItem({
    super.key,
    required this.task,
    required this.onChanged,
    required this.onDismissedLeft,
    required this.onDismissedRight,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      background: Container(
        color: Colors.blue,
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
          onDismissedLeft();
        } else if (direction == DismissDirection.endToStart) {
          onDismissedRight();
        }
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
            ],
          ),
        ),
      ),
    );
  }
}
