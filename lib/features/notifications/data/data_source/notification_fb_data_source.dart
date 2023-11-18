import 'package:firebase_messaging/firebase_messaging.dart';

abstract class NotificationFbDataSource {
  Future<void> setForegroundNotificationPresentationOptions({
    bool alert,
    bool badge,
    bool sound,
  });

  Future<RemoteMessage?> getInitialMessage();

  Stream<RemoteMessage> onMessageOpenedApp();

  Future<void> requestPermission({
    bool alert,
    bool announcement,
    bool badge,
    bool sound,
  });

  Future<String?> getToken();
}
