import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:my_office/leave_apply/leave_apply_screen.dart';
import 'package:my_office/refreshment/refreshment_screen.dart';
import 'package:my_office/suggestions/suggestions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_office/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../constant/app_defaults.dart';
import '../main.dart';
import '../suggestions/view_suggestions.dart';

class NotificationType {
  static const leaveNotification = 'leaveApplied';
  static const leaveRespond = 'leaveResponse';
  static const suggestion = 'suggestion';
}

// handling background messages
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  log('Title is ${message.notification!.title}');
  log('Body is ${message.notification!.body}');
  log('Payload is ${message.data}');
}

class NotificationService {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final userRef = FirebaseDatabase.instance.ref('fcm_tokens');

  Future<void> _initPushNotifications() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    _firebaseMessaging.getInitialMessage().then(_onNotificationClick);
    FirebaseMessaging.onMessageOpenedApp.listen(_onNotificationClick);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  // -- Handling notification onClick --
  void _onNotificationClick(RemoteMessage? message) {
    if (message == null) return;
    try {
      if (message.data['type'] == NotificationType.leaveNotification) {
        navigationKey.currentState!.push(
          MaterialPageRoute(
            builder: (_) => const LeaveApplyScreen(),
          ),
        );
      } else if (message.data['type'] == NotificationType.leaveRespond) {
        navigationKey.currentState!.push(
          MaterialPageRoute(
            builder: (_) => const LeaveApplyScreen(),
          ),
        );
      } else if (message.data['type'] == NotificationType.suggestion) {
        navigationKey.currentState!.push(
          MaterialPageRoute(
            builder: (_) => const ViewSuggestions(),
          ),
        );
      }
    } catch (e) {
      log('Error from FCM notification $e');
    }
  }

  // initialization of FCM
  Future<void> initFCMNotifications() async {
    await _firebaseMessaging.requestPermission(
        alert: true, announcement: false, badge: true, sound: true);
    _initPushNotifications();
  }

  // -- Notification related --
  Future<void> storeFCM({required BuildContext context}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final fcmToken = await FirebaseMessaging.instance.getToken();
    final deviceId = await getDeviceId();
    if (userProvider != null) {
      await userRef.child(userProvider.user!.uid).once().then((value) async {
        if (value.snapshot.exists) {
          for (var device in value.snapshot.children) {
            final tokenData = device.value as Map<Object?, Object?>;

            /// Removing duplicate token if device id is same and identifier is different
            if (device.key != userProvider.user!.uniqueId &&
                tokenData['deviceId'].toString() == deviceId) {
              await removeFCM(
                  userId: userProvider.user!.uid,
                  uniqueId: device.key.toString());
            }
          }
        }
      });
      await userRef
          .child('${userProvider.user!.uid}/${userProvider.user!.uniqueId}')
          .set({'token': fcmToken, 'deviceId': deviceId});
    }
  }

  Future<void> removeFCM(
      {required String userId, required String uniqueId}) async {
    await userRef.child('$userId/$uniqueId').remove();
  }

  Future<List<String>> getDeviceFcm({required String userId}) async {
    List<String> fcm = [];
    try {
      await userRef.child(userId).once().then((value) {
        if (value.snapshot.exists) {
          for (var token in value.snapshot.children) {
            final tokenData = token.value as Map<Object?, Object?>;
            fcm.add(tokenData['token'].toString());
          }
        }
      });
    } catch (e) {
      log('Error in getDeviceFcm $e');
    }
    return fcm;
  }

  static Future<String> getDeviceId() async {
    String id = '';
    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      id = '${deviceInfo.model}-${deviceInfo.id}';
    }
    if (Platform.isIOS) {
      final deviceInfo = await DeviceInfoPlugin().iosInfo;
      id = '${deviceInfo.model}-${deviceInfo.name}';
    }
    return id;
  }

  Future<void> sendNotification(
      {required String title,
      required String body,
      required String token,
      String? type}) async {
    try {
      const url = 'https://fcm.googleapis.com/fcm/send';
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      };

      final payload = {
        'notification': {
          'title': 'My Office: $title',
          'body': body,
        },
        'priority': 'high',
        'data': {'type': type},
        'to': token,
      };

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(payload),
      );
      if (response.statusCode == 200) {
        log('Notification sent');
      } else {
        log('Notification sending failed');
      }
    } catch (e) {
      log('Error in sendHomeInviteNotification $e');
    }
  }

  // LOCAL NOTIFICATION //
  static final _notifications = FlutterLocalNotificationsPlugin();

  //init
  Future<void> initializePlatformNotifications() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/suitcase');
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {},
    );
    InitializationSettings settings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()!
        .requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
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
  Future<void> showDailyNotificationWithPayload(
      {required String setTime}) async {
    //Notification setting main function
    setNotification() async {
      final pref = await SharedPreferences.getInstance();
      final currentTime = DateTime.now();
      final notTimeMng =
          DateTime(currentTime.year, currentTime.month, currentTime.day, 9, 30);
      final notTimeEvg = DateTime(
          currentTime.year, currentTime.month, currentTime.day, 14, 00);

      final detail = await _notificationDetails();

      const title = 'Refreshment time';
      const body = 'Place your Refreshment orders here.';
      // 10 AM

      for (int i = 0; i < 8; i++) {
        final notificationTimeMorning = notTimeMng.add(Duration(days: i));
        final notificationTimeEvening = notTimeEvg.add(Duration(days: i));

        //Morning notification
        if (notificationTimeMorning.weekday != 7) {
          if (currentTime.hour >= 10 && i == 0) {
            // print('Morning time already passed');
          } else {
            log("Notification set for mng $notificationTimeMorning");
            _notifications.zonedSchedule(
              i + 1,
              title,
              body,
              tz.TZDateTime.from(notificationTimeMorning, tz.local),
              detail,
              uiLocalNotificationDateInterpretation:
                  UILocalNotificationDateInterpretation.absoluteTime,
              androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            );
          }
        }

        //Evening notification
        if (notificationTimeEvening.weekday != 7) {
          if (currentTime.hour >= 14 && i == 0) {
            // print('Evening time already passed');
          } else {
            log("Notification set for Evg $notificationTimeEvening");
            _notifications.zonedSchedule(
              i + 10,
              title,
              body,
              tz.TZDateTime.from(notificationTimeEvening, tz.local),
              detail,
              androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
              uiLocalNotificationDateInterpretation:
                  UILocalNotificationDateInterpretation.absoluteTime,
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
