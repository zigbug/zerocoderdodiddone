import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_auth.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _tasksCollection = FirebaseFirestore.instance
      .collection('tasks${AuthenticationService().currentUser?.uid}');

  // Получение всех задач
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getTasks() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await _tasksCollection.get() as QuerySnapshot<Map<String, dynamic>>;
    return snapshot.docs;
  }

  // Получение потока всех задач
  Stream<QuerySnapshot<Map<String, dynamic>>> getTasksStream() {
    return _tasksCollection.snapshots()
        as Stream<QuerySnapshot<Map<String, dynamic>>>;
  }

  // Получение задачи по ID
  Future<DocumentSnapshot<Map<String, dynamic>>> getTaskById(
      String taskId) async {
    return await _tasksCollection.doc(taskId).get()
        as DocumentSnapshot<Map<String, dynamic>>;
  }

  // Добавление новой задачи
  Future<void> addTask(
      {required String title,
      required String description,
      required DateTime deadline,
      required bool remind}) async {
    await _tasksCollection.add({
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
    await _tasksCollection.doc(taskId).update({
      'title': title ?? '',
      'description': description ?? '',
      'deadline': deadline ?? DateTime.now(),
      'remind': remind ?? false,
    });
  }

  // Удаление задачи
  Future<void> deleteTask(String taskId) async {
    await _tasksCollection.doc(taskId).delete();
  }

  // Изменение статуса завершения задачи
  Future<void> toggleTaskCompletion(String taskId) async {
    DocumentSnapshot<Map<String, dynamic>> task = await _tasksCollection
        .doc(taskId)
        .get() as DocumentSnapshot<Map<String, dynamic>>;
    await _tasksCollection.doc(taskId).update({
      'completed': !task.data()!['completed'],
    });
  }
}
