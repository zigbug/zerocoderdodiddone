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
      stream: _tasksCollection
          .where('isCompleted', isEqualTo: false)
          .where('isForToday', isEqualTo: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Ошибка загрузки задач');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final tasks = snapshot.data!.docs.map((doc) {
          var task = Task.fromMap(doc.data() as Map<String, dynamic>);
          task = task.copyWith(id: doc.id);
          return task;
        }).toList(); //.where((task) => task.isCompleted == false&&task.isForToday==false).toList()

        if (tasks.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                'Всё сделано, время отдыхать... \nили добавить новую задачу?!',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return TaskItem(
              screen: Screen.allTasks,
              task: task,
              onDelete: () async {
                await _tasksCollection.doc(task.id).delete();
              },
              onChanged: (value) {
                // Обновление статуса задачи в Firebase
                _tasksCollection.doc(task.id).update({
                  'isCompleted': value,
                });
              },
              onDismissedLeft: () async {
                await _tasksCollection
                    .doc(task.id)
                    .update(task.copyWith(isForToday: true).toJson());
              },
              onDismissedRight: () async {
                await _tasksCollection
                    .doc(task.id)
                    .update(task.copyWith(isCompleted: true).toJson());
              },
              onEdit: () {},
            );
          },
        );
      },
    );
  }
}
