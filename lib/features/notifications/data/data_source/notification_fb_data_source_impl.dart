import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:my_office/features/notifications/data/data_source/notification_fb_data_source.dart';

class NotificationFbDataSourceImpl implements NotificationFbDataSource {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  Future<void> setForegroundNotificationPresentationOptions({
    bool alert = true,
    bool badge = true,
    bool sound = true,
  }) async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: alert,
      badge: badge,
      sound: sound,
    );
  }

  @override
  Future<RemoteMessage?> getInitialMessage() async {
    return _firebaseMessaging.getInitialMessage();
  }

  @override
  Stream<RemoteMessage> onMessageOpenedApp() {
    return FirebaseMessaging.onMessageOpenedApp;
  }

  @override
  Future<void> requestPermission({
    bool alert = true,
    bool announcement = false,
    bool badge = true,
    bool sound = true,
  }) async {
    await _firebaseMessaging.requestPermission(
      alert: alert,
      announcement: announcement,
      badge: badge,
      sound: sound,
    );
  }

  @override
  Future<String?> getToken() async {
    return _firebaseMessaging.getToken();
  }
}
