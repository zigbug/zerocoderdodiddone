import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/task_item.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final CollectionReference _tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _tasksCollection.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Ошибка при загрузке задач'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final tasks = snapshot.data!.docs;

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final taskData = tasks[index].data() as Map<String, dynamic>;
            final taskTitle = taskData['title'];
            final taskDescription = taskData['description'];
            final taskDeadline = taskData['deadline'];

            return TaskItem(
              title: taskTitle,
              description: taskDescription,
              deadline: taskDeadline ?? DateTime.now(),
              // Добавьте обработчики для изменения и удаления задач
              onEdit: () {
                // Обработка изменения задачи
                // Например, можно открыть диалог для редактирования
              },
              onDelete: () {
                // Обработка удаления задачи
                // Например, можно показать диалог подтверждения
                _tasksCollection.doc(tasks[index].id).delete();
              },
            );
          },
        );
      },
    );
  }
}




// import 'package:flutter/material.dart';

// import '../widgets/task_item.dart';

// class TasksPage extends StatefulWidget {
//   const TasksPage({Key? key}) : super(key: key);

//   @override
//   State<TasksPage> createState() => _TasksPageState();
// }

// class _TasksPageState extends State<TasksPage> {
//   final List<String> _tasks = [
//     'Купить продукты',
//     'Записаться на прием к врачу',
//     'Позвонить маме',
//     'Сделать уборку',
//     'Прочитать книгу',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: _tasks.length,
//       itemBuilder: (context, index) {
//         return TaskItem(
//           title: _tasks[index],
//           description: 'Описание задачи',
//           deadline: DateTime.now(),
//         );
//       },
//     );
//   }
// }
