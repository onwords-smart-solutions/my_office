import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:my_office/features/notifications/data/data_source/notification_fb_data_source.dart';

class NotificationRepository {
  final NotificationFbDataSource notificationFbDataSource;

  NotificationRepository(this.notificationFbDataSource);

  Future<void> initNotifications() async {
    await notificationFbDataSource.requestPermission();
    await notificationFbDataSource.setForegroundNotificationPresentationOptions();
  }

  Stream<RemoteMessage> onMessageOpenedAppStream() {
    return notificationFbDataSource.onMessageOpenedApp();
  }

  Future<String?> getFcmToken() async {
    return notificationFbDataSource.getToken();
  }
}
