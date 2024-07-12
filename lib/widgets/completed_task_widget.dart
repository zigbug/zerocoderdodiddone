import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zerocoderdodiddone/models/task_model.dart';

class CompletedTasksWidget extends StatefulWidget {
  const CompletedTasksWidget({Key? key}) : super(key: key);

  @override
  State<CompletedTasksWidget> createState() => _CompletedTasksWidgetState();
}

class _CompletedTasksWidgetState extends State<CompletedTasksWidget> {
  final CollectionReference _tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _tasksCollection
          .where('isCompleted', isEqualTo: true) // Фильтр по полю isCompleted
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Ошибка загрузки задач');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final tasks = snapshot.data!.docs.map((doc) {
          return Task.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();

        if (tasks.isEmpty) {
          return const Center(
            child: Text('Нет завершённых задач'),
          );
        }

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return TaskWidget(
              task: task,
              onDismissedLeft: (task) {
                // Обновление поля "на сегодня" в Firebase
                _tasksCollection.doc(task.id).update({
                  'isForToday': !task.isForToday,
                });
              },
              onDismissedRight: (task) {
                // Обновление статуса задачи в Firebase
                _tasksCollection.doc(task.id).update({
                  'isCompleted': !task.isCompleted,
                });
              },
            );
          },
        );
      },
    );
  }
}
