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
            color: Color(0xff8355B7));
    return NotificationDetails(android: androidNotificationDetails);
  }

  //showing notification function
  Future<void> showDailyNotification() async {
    final detail = await _notificationDetails();
    var time = const Time(10, 10, 0);


    final List<PendingNotificationRequest> pendingNotificationRequests =
    await _notifications.pendingNotificationRequests();
    print('Pending list is ${pendingNotificationRequests.length}');

    var now = DateTime.now();
    var scheduledDate =
        now.weekday == DateTime.sunday ? now.add(const Duration(days: 1)) : now;

    var scheduledTime = Time(time.hour, time.minute, time.second);
    DateTime dateTime = DateTime(scheduledDate.year, scheduledDate.month,
        scheduledDate.day, scheduledTime.hour, scheduledTime.minute);
    var scheduledDateTime = tz.TZDateTime.from(dateTime, tz.local);

    await _notifications.zonedSchedule(0, 'Daily Notification',
        'This is your daily notification', scheduledDateTime, detail,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);

  }
}
