import 'package:flutter/material.dart';

import '../models/task_model.dart';
enum Screen{
allTasks,
forToday,
completed
 }

class TaskItem extends StatelessWidget {
  final Task task;
  final Screen screen;
  final void Function(bool?) onChanged;
  final void Function() onDismissedLeft;
  final void Function() onDismissedRight;
  final void Function() onEdit; // Добавляем функцию onEdit
  final List<Widget> icons=const [ 
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
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.createdAt.toString()),
      //смещение слева направо
      background: Container(
        color: Colors.blue,
        child:  Align(
          alignment: Alignment.centerLeft,
          child:  icons[screen.index],
        ),
      ),
      secondaryBackground: Container(
        color: Colors.green,
        child:  Align(
          alignment: Alignment.centerRight,
          child:  icons[(screen.index + 1) % icons.length],
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
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: double.infinity,),
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
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  onPressed: onEdit, // Вызываем функцию onEdit при нажатии
                  icon: const Icon(Icons.edit),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

