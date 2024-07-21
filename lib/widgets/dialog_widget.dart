import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/notification_sevrvice.dart';

class DialogWidget extends StatefulWidget {
  const DialogWidget(
      {super.key, this.title, this.description, this.deadline, this.taskId});
  final String? title;
  final String? description;
  final DateTime? deadline;
  final String? taskId; // ID задачи для редактирования

  @override
  State<DialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  String? _title;
  String? _description;
  DateTime? _deadline;
  bool _remind = false; // Добавлено поле для состояния Switch

  @override
  void initState() {
    super.initState();
    _title = widget.title;
    _description = widget.description;
    _deadline = widget.deadline;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        width: 400,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller:
                    TextEditingController(text: _title), // Предзаполнение
                decoration: const InputDecoration(labelText: 'Название'),
                onChanged: (value) {
                  _title = value;
                },
              ),
              TextField(
                controller:
                    TextEditingController(text: _description), // Предзаполнение
                decoration: const InputDecoration(labelText: 'Описание'),
                onChanged: (value) {
                  _description = value;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  children: [
                    Text(
                      'Дедлайн: ${DateFormat('dd.MM.yy HH:mm').format(_deadline ?? DateTime.now())}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: _deadline ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        ).then((pickedDate) {
                          if (pickedDate != null) {
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                  _deadline ?? DateTime.now()),
                            ).then((pickedTime) {
                              if (pickedTime != null) {
                                setState(() {
                                  _deadline = DateTime(
                                    pickedDate.year,
                                    pickedDate.month,
                                    pickedDate.day,
                                    pickedTime.hour,
                                    pickedTime.minute,
                                  );
                                });
                              }
                            });
                          }
                        });
                      },
                      icon: const Icon(Icons.calendar_today),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  children: [
                    const Text('Напомнить:'),
                    Switch(
                      value: _remind,
                      onChanged: (value) {
                        setState(() {
                          _remind = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Отмена'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final tasksCollection =
                          FirebaseFirestore.instance.collection('tasks');

                      if (widget.taskId != null) {
                        // Редактирование существующей задачи
                        await tasksCollection.doc(widget.taskId).update({
                          'title': _title,
                          'description': _description,
                          'deadline': _deadline,
                          'remind': _remind, // Добавлено поле 'remind'
                        });
                      } else {
                        // Добавление новой задачи
                        await tasksCollection.add({
                          'title': _title,
                          'description': _description,
                          'deadline': _deadline,
                          'completed': false,
                          'is_for_today': false,
                          'remind': _remind, // Добавлено поле 'remind'
                        });
                      }
                      if (_remind) {
                        await NotificationService.showNotification(
                            id: 11,
                            title: _title ?? 'задача',
                            body: _description ?? 'описания нет',
                            scheduledDate: _deadline!
                                .subtract(const Duration(seconds: 20)));
                      }
                      Navigator.pop(context);
                    },
                    child:
                        Text(widget.taskId != null ? 'Сохранить' : 'Добавить'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
