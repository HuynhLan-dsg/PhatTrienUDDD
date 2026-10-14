import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService instance = NotificationService._internal();
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings = InitializationSettings(android: androidSettings);

    await plugin.initialize(settings: settings);
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required DateTime datetime,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'todo_channel',
      'Todo Channel',
      channelDescription: 'Thông báo công việc',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await plugin.zonedSchedule(
      id: id,
      title: title,
      body: 'Đã đến hạn công việc',
      scheduledDate: tz.TZDateTime.from(datetime, tz.local),
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> showCompletedNotification(int count) async {
    const androidDetails = AndroidNotificationDetails(
      'completed_channel',
      'Completed Channel',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await plugin.show(
      id: 999,
      title: 'Hoàn thành nhiệm vụ',
      body: 'Bạn đã hoàn thành $count nhiệm vụ',
      notificationDetails: details,
    );
  }

  Future<void> scheduleTaskNotification({
    required int id,
    required String taskTitle,
    required String reminderTime,
  }) async {
    final now = DateTime.now();

    final parts = reminderTime.split(':');

    final scheduleDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );

    const androidDetails = AndroidNotificationDetails(
      'task_channel',
      'Task Channel',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await plugin.zonedSchedule(
      id: id,
      title: taskTitle,
      body: 'Đã đến giờ thực hiện nhiệm vụ',
      scheduledDate: scheduleDate,
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
