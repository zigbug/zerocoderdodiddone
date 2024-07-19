import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DialogWidget extends StatefulWidget {
  const DialogWidget({super.key, this.title, this.description, this.deadline});
  final String? title;
  final String? description;
  final DateTime? deadline;

  @override
  State<DialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  String? _title;
  String? _description;
  DateTime? _deadline;

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
      // Используем Dialog вместо AlertDialog для настройки ширины
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Скругленные углы
      ),
      child: SizedBox(
        width: 400, // Устанавливаем ширину диалога
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Отступ для содержимого
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Название'),
                onChanged: (value) {
                  _title = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Описание'),
                onChanged: (value) {
                  _description = value;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0), // Отступ сверху
                child: Row(
                  children: [
                    Text(
                      'Дедлайн: ${DateFormat('dd.MM.yy HH:mm').format(_deadline ?? DateTime.now())}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      onPressed: () {
                        // Открыть календарь для выбора даты и времени
                        showDatePicker(
                          context: context,
                          initialDate: _deadline,
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        ).then((pickedDate) {
                          if (pickedDate != null) {
                            // После выбора даты, открыть TimePicker
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
              const SizedBox(height: 20), // Отступ снизу
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
                      // Добавление задачи в FirebaseFirestore
                      final tasksCollection =
                          FirebaseFirestore.instance.collection('tasks');
                      await tasksCollection.add({
                        'title': _title,
                        'description': _description,
                        'deadline': _deadline,
                        'completed': false,
                        'is_for_today': false,
                      });

                      Navigator.pop(context);
                    },
                    child: const Text('Добавить'),
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
