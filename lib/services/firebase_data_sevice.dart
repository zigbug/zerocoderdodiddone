import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_auth.dart';

class TaskService {
  final CollectionReference tasksCollection = FirebaseFirestore.instance
      .collection('tasks${AuthenticationService().currentUser?.uid}');

  // Получение всех задач
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getTasks() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await tasksCollection.get() as QuerySnapshot<Map<String, dynamic>>;
    return snapshot.docs;
  }

  // Получение потока всех задач
  Stream<QuerySnapshot<Map<String, dynamic>>> getTasksStream() {
    return tasksCollection.snapshots()
        as Stream<QuerySnapshot<Map<String, dynamic>>>;
  }

  // Получение задачи по ID
  Future<DocumentSnapshot<Map<String, dynamic>>> getTaskById(
      String taskId) async {
    return await tasksCollection.doc(taskId).get()
        as DocumentSnapshot<Map<String, dynamic>>;
  }

  // Добавление новой задачи
  Future<void> addTask(
      {required String title,
      required String description,
      required DateTime deadline,
      required bool remind}) async {
    await tasksCollection.add({
      'title': title,
      'description': description,
      'deadline': deadline,
      'completed': false,
      'is_for_today': false,
      'remind': remind,
    });
  }

  // Обновление задачи
  Future<void> updateTask(
      {required String taskId,
      required String? title,
      required String? description,
      required DateTime? deadline,
      required bool? remind}) async {
    await tasksCollection.doc(taskId).update({
      'title': title ?? '',
      'description': description ?? '',
      'deadline': deadline ?? DateTime.now(),
      'remind': remind ?? false,
    });
  }

  // Удаление задачи
  Future<void> deleteTask(String taskId) async {
    await tasksCollection.doc(taskId).delete();
  }

  // Изменение статуса завершения задачи
  Future<void> toggleTaskCompletion(String taskId) async {
    await tasksCollection.doc(taskId).update({
      'completed': true,
      'is_for_today': false,
    });
  }

  Future<void> toggleTaskForToday(String taskId) async {
    await tasksCollection.doc(taskId).update({
      'completed': false,
      'is_for_today': true,
    });
  }

  Future<void> toggleTaskForAll(String taskId) async {
    await tasksCollection.doc(taskId).update({
      'completed': false,
      'is_for_today': false,
    });
  }
}
