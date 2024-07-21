import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zerocoderdodiddone/services/firebase_data_sevice.dart';
import 'package:zerocoderdodiddone/widgets/dialog_widget.dart'; // Импортируем пакет intl

class TaskItem extends StatelessWidget {
  final int screenIndex;
  final TaskService taskService;
  final String taskId;
  final String title;
  final String description;
  final DateTime deadline;
  final Function? toLeft;
  final Function? toRight; // Функция для удаления

  const TaskItem({
    super.key,
    required this.title,
    required this.description,
    required this.deadline,
    this.toLeft,
    this.toRight,
    required this.taskId,
    required this.taskService,
    required this.screenIndex,
  });

  @override
  Widget build(BuildContext context) {
    // Форматируем дату и время
    String formattedDeadline = DateFormat('dd.MM.yy HH:mm').format(deadline);
    List<IconData> icons = [
      Icons.list,
      Icons.calendar_today,
      Icons.check_circle
    ];

    // Определяем срочность задачи
    Duration timeUntilDeadline = deadline.difference(DateTime.now());
    Color gradientStart;
    if (timeUntilDeadline.inDays < 1) {
      gradientStart = Colors.red; // Срочная
    } else if (timeUntilDeadline.inDays < 2) {
      gradientStart = Colors.yellow; // Средняя срочность
    } else {
      gradientStart = Colors.green; // Не срочная
    }

    return Dismissible(
      key: Key(title), // Уникальный ключ для Dismissible
      background: Container(
        color: Colors.green,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(right: 20.0),
        child: Icon(
          icons[(screenIndex + 1) % 3], // Иконка для перехода "На сегодня"
          color: Colors.white,
        ),
      ),
      secondaryBackground: Container(
        color: Colors.blue,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(left: 20.0),
        child: Icon(
          icons[(screenIndex - 1 < 0) ? 2 : screenIndex - 1],
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          // Вызываем функцию, если элемент был сдвинут влево
          toLeft?.call();
        } else if (direction == DismissDirection.startToEnd) {
          // Вызываем функцию, если элемент был сдвинут вправо
          toRight?.call();
        }
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    gradientStart,
                    Theme.of(context).brightness == Brightness.light
                        ? Colors.white
                        : Colors.black54,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Цвет текста черный
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Обработка изменения задачи
                      showDialog(
                        context: context,
                        builder: (context) {
                          return DialogWidget(
                            taskId: taskId,
                            title: title,
                            description: description,
                            deadline: deadline,
                            taskService: taskService,
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () async {
                      await TaskService().deleteTask(taskId);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Дедлайн: $formattedDeadline', // Используем отформатированную дату
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
