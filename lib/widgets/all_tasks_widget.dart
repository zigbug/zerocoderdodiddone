import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zerocoderdodiddone/models/task_model.dart';
import 'package:zerocoderdodiddone/widgets/task_item.dart';

class AllTasksWidget extends StatefulWidget {
  const AllTasksWidget({super.key});

  @override
  State<AllTasksWidget> createState() => _AllTasksWidgetState();
}

class _AllTasksWidgetState extends State<AllTasksWidget> {
  final CollectionReference _tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _tasksCollection.snapshots(),
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
            child: Text(
                'Всё сделано, время отдыхать... или добавить новую задачу?!'),
          );
        }

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return TaskItem(
              task: task,
              onChanged: (value) {
                // Обновление статуса задачи в Firebase
                _tasksCollection.doc(task.id).update({
                  'isCompleted': value,
                });
              },
              onDismissedLeft: () {
                task.toggleForToday();
                _tasksCollection.doc(task.id).update({
                  'forToday': task.isForToday,
                });
              },
              onDismissedRight: () {
                task.toggleCompleted();
                _tasksCollection.doc(task.id).update({
                  'isCompleted': task.isCompleted,
                });
              },
            );
          },
        );
      },
    );
  }
}
