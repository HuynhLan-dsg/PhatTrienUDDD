import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class VocabularyServices {
  static final VocabularyServices instance =
      VocabularyServices._internal();

  VocabularyServices._internal();

  final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings =
        InitializationSettings(
      android: androidSettings,
    );

    await plugin.initialize(
      settings: settings,
    );
  }

  Future<void> scheduleVocabularyReminder({
    required int id,
    required String word,
  }) async {
    const androidDetails =
        AndroidNotificationDetails(
      'vocabulary_channel',
      'Vocabulary Channel',
      channelDescription:
          'Nhắc học từ vựng',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details =
        NotificationDetails(
      android: androidDetails,
    );

    final scheduleDate =
        tz.TZDateTime.now(tz.local).add(
      const Duration(minutes: 10),
    );

    await plugin.zonedSchedule(
      id: id,
      title: 'Ôn tập từ vựng',
      body: 'Hãy xem lại từ: $word',
      scheduledDate: scheduleDate,
      notificationDetails: details,
      androidScheduleMode:
          AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}