import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zerocoderdodiddone/models/task_model.dart';
import 'package:zerocoderdodiddone/widgets/task_item.dart';

class TodayTasksWidget extends StatefulWidget {
  const TodayTasksWidget({super.key});

  @override
  State<TodayTasksWidget> createState() => _TodayTasksWidgetState();
}

class _TodayTasksWidgetState extends State<TodayTasksWidget> {
  final CollectionReference _tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _tasksCollection
          .where('isForToday', isEqualTo: true) // Фильтр по полю isForToday
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
            child: Text('Нет задач на сегодня'),
          );
        }

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return TaskItem(
              task: task,
              onDelete: () async {
                await _tasksCollection.doc(task.id).delete();
              },
              screen: Screen.forToday,
              onChanged: (value) async {
                // Обновление статуса задачи в Firebase
                await _tasksCollection.doc(task.id).update({
                  'isCompleted': value,
                });
              },
              onDismissedLeft: () async {
                await _tasksCollection.doc(task.id).update({
                  'isForToday': !task.isForToday,
                  'isCompleted': !task.isCompleted,
                });
              },
              onDismissedRight: () async {
                // Обновление поля "на сегодня" в Firebase
                await _tasksCollection.doc(task.id).update({
                  'isForToday': !task.isForToday,
                });
              },
              onEdit: () {},
            );
            //  TaskWidget(
            //   task: task,
            //   onDismissedLeft: (task) async{
            //     await  _tasksCollection.doc(task.id).update({
            //       'isForToday': !task.isForToday,

            //       'isCompleted': !task.isCompleted,
            //     });

            //   },
            //   onDismissedRight: (task) async {

            //   // Обновление поля "на сегодня" в Firebase
            //    await _tasksCollection.doc(task.id).update({
            //       'isForToday': !task.isForToday,
            //     });
            //   },
            // );
          },
        );
      },
    );
  }
}
