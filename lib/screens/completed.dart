import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/firebase_data_sevice.dart';
import '../widgets/task_item.dart';

class ComplededPage extends StatefulWidget {
  const ComplededPage({super.key, required this.taskService});
  final TaskService taskService;

  @override
  State<ComplededPage> createState() => _ComplededPageState();
}

class _ComplededPageState extends State<ComplededPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.taskService.tasksCollection
          .where('completed', isEqualTo: true)
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
              child: Text('Нет завершённых задач, время действовать!'));
        }

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final taskData = tasks[index].data() as Map<String, dynamic>;
            final taskTitle = taskData['title'];
            final taskDescription = taskData['description'];
            final taskDeadline = (taskData['deadline'] as Timestamp).toDate();

            return TaskItem(
              taskService: widget.taskService,
              title: taskTitle,
              description: taskDescription,
              deadline: taskDeadline,
              toLeft: () async {
                await widget.taskService.toggleTaskForToday(tasks[index].id);
              },
              toRight: () async {
                await widget.taskService.toggleTaskForAll(tasks[index].id);
              },

              // Добавьте обработчики для изменения и удаления задач

              taskId: tasks[index].id, screenIndex: 2,
            );
          },
        );
      },
    );
  }
}
