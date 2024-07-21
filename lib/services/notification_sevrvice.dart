import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    tz.initializeTimeZones();
    // const DarwinInitializationSettings initializationSettingsIOS =
    //     DarwinInitializationSettings(
    //   requestSoundPermission: false,
    //   requestBadgePermission: false,
    //   requestAlertPermission: false,
    // );
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      // iOS: initializationSettingsIOS,
    );
    await _notificationsPlugin.initialize(initializationSettings);

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> showNotification(
      {required int id,
      required String title,
      required String body,
      int? seconds,
      DateTime? scheduledDate}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'канал для уведомлений',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
    // const DarwinInitializationSettings iOSPlatformChannelSpecifics =
    //     DarwinInitializationSettings(
    //   sound: 'default',
    //   presentAlert: true,
    //   presentBadge: true,
    // );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      // iOS: iOSPlatformChannelSpecifics,
    );

    if (scheduledDate != null) {
      // Отложенное уведомление
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        // Запланируйте уведомление на определенное время
        tz.TZDateTime.from(scheduledDate, tz.local),
        platformChannelSpecifics,
        // androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
      );
    } else {
      // Немедленное уведомление
      await _notificationsPlugin.show(
        id,
        title,
        body,
        platformChannelSpecifics,
        payload: 'item x',
        // timeoutAfter: seconds != null ? Duration(seconds: seconds) : null,
      );
    }
  }

  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
}
