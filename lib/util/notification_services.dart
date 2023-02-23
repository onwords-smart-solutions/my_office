import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  //init
  Future<void> initializePlatformNotifications() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@drawable/suitcase');
    const InitializationSettings settings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notifications.initialize(
      settings,
    );
  }

  Future<NotificationDetails> _notificationDetails() async {
    AndroidNotificationDetails androidNotificationDetails =
    const AndroidNotificationDetails('My Office', 'Refreshment',
        groupKey: 'com.onwords.my_office',
        channelDescription: 'Notifications for refreshment reminder',
        importance: Importance.max,
        priority: Priority.high,
        enableLights: true,
        sound: RawResourceAndroidNotificationSound('alarm'),
        autoCancel: false,
        audioAttributesUsage: AudioAttributesUsage.notificationRingtone,
        playSound: true,
        fullScreenIntent: true,
        onlyAlertOnce: false,
        enableVibration: true,
        channelAction: AndroidNotificationChannelAction.createIfNotExists,
        color: Color(0xff8355B7));
    return NotificationDetails(android: androidNotificationDetails);
  }

  //showing notification function
  Future<void> showDailyNotification() async {
    final now = DateTime.now();
    final isWeekend = now.weekday == DateTime.sunday;
    if (isWeekend) {
      // Don't schedule notification on weekends
      return;
    }

    const channelId = 'my_channel_id';
    const channelName = 'My channel';
    const channelDescription = 'My channel description';
    const importance = Importance.max;

    const title = 'My Notification Title';
    const body = 'This is my notification message';
    final scheduledDate = DateTime(now.year, now.month, now.day, 10, 0, 0); // 10 AM
  }
}
