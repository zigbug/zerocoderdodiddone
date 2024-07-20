import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/dialog_widget.dart';
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
      stream: _tasksCollection
          .where('completed', isEqualTo: false)
          .where('is_for_today', isEqualTo: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Ошибка при загрузке задач'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final tasks = snapshot.data!.docs;

        if (tasks.isEmpty) {
          return const Center(
              child: Text(
                  'Нет задач, время отдыхать.. \n или создать новую задачу?'));
        }

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final taskData = tasks[index].data() as Map<String, dynamic>;
            final taskTitle = taskData['title'];
            final taskDescription = taskData['description'];
            final taskDeadline = (taskData['deadline'] as Timestamp).toDate();

            return TaskItem(
              title: taskTitle,
              description: taskDescription,
              deadline: taskDeadline ?? DateTime.now(),
              toLeft: () {
                _tasksCollection
                    .doc(tasks[index].id)
                    .update({'completed': true});
              },
              toRight: () {
                _tasksCollection
                    .doc(tasks[index].id)
                    .update({'is_for_today': true});
              },

              // Добавьте обработчики для изменения и удаления задач
              onEdit: () {
                // Обработка изменения задачи
                showDialog(
                  context: context,
                  builder: (context) {
                    return DialogWidget(
                      taskId: tasks[index].id,
                      title: taskTitle,
                      description: taskDescription,
                      deadline: taskDeadline,
                    );
                  },
                );
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
