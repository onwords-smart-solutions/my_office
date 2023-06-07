import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
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
    _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()!.requestPermission();
    await _notifications.initialize(
      settings,
    );
  }

  Future<NotificationDetails> _notificationDetails() async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails('My Office', 'Refreshment',
            groupKey: 'com.onwords.office',
            channelDescription: 'Notifications for refreshment reminder',
            importance: Importance.max,
            priority: Priority.high,
            enableLights: true,
            sound: RawResourceAndroidNotificationSound('office'),
            autoCancel: false,
            // audioAttributesUsage: AudioAttributesUsage.notification,
            playSound: true,
            fullScreenIntent: true,
            onlyAlertOnce: false,
            enableVibration: true,
            channelAction: AndroidNotificationChannelAction.createIfNotExists,
            color: Color(0xff8355B7));
    return NotificationDetails(android: androidNotificationDetails);
  }

  //showing notification function
  Future<void> showDailyNotificationWithPayload({required String setTime}) async {
    //Notification setting main function
    setNotification() async {
      final pref = await SharedPreferences.getInstance();
      final currentTime = DateTime.now();
      final notTimeMng = DateTime(
          currentTime.year, currentTime.month, currentTime.day, 10, 00);
      final notTimeEvg = DateTime(
          currentTime.year, currentTime.month, currentTime.day, 14, 00);

      final detail = await _notificationDetails();

      const title = 'Refreshment time';
      const body = 'Don\'t forget to update your refreshment preferences.';
      // 10 AM

      for (int i = 0; i < 8; i++) {
        final notificationTimeMorning = notTimeMng.add(Duration(days: i));
        final notificationTimeEvening = notTimeEvg.add(Duration(days: i));

        //Morning notification
        if (notificationTimeMorning.weekday != 7) {
          if (currentTime.hour >= 10 && i == 0) {
            // print('Morining time already passed');
          } else {
            log("Notification set for mng $notificationTimeMorning");
            _notifications.zonedSchedule(
              i+1,
              title,
              body,
              tz.TZDateTime.from(notificationTimeMorning, tz.local),

              detail,
              uiLocalNotificationDateInterpretation:
                  UILocalNotificationDateInterpretation.absoluteTime,
              androidAllowWhileIdle: true,
            );

          }
        }

        //Evening notificaiton
        if (notificationTimeEvening.weekday != 7) {
          if (currentTime.hour >= 14 && i == 0) {
            // print('Evening time already passed');
          } else {
            log("Notification set for Evg $notificationTimeEvening");
            _notifications.zonedSchedule(
              i+10,
              title,
              body,
              tz.TZDateTime.from(notificationTimeEvening, tz.local),
              detail,
              uiLocalNotificationDateInterpretation:
                  UILocalNotificationDateInterpretation.absoluteTime,
              androidAllowWhileIdle: true,
            );
          }
        }
      }

      //Setting time in shared preference
      await pref.setString('NotificationSetTime', currentTime.toString());
    }

    DateTime currentTime = DateTime.now();
    if (setTime.isNotEmpty) {
      final notificationSetTime = DateTime.parse(setTime);
      if (currentTime
              .compareTo(notificationSetTime.add(const Duration(days: 6))) >
          0) {
        //notification set time is passed
        setNotification();
      }
    } else {
      //first time notification setting
      setNotification();
    }
  }
}
