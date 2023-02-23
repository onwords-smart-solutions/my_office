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

  }
}
