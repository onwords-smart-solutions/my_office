import 'package:firebase_database/firebase_database.dart';
import 'package:my_office/features/notifications/data/data_source/user_fb_data_source.dart';

class UserRepository {
  final UserFbDataSource userFbDataSource;

  UserRepository(this.userFbDataSource);

  Future<void> storeUserFCM(
    String userId,
    String uniqueId,
    String token,
    String deviceId,
  ) async {
    await userFbDataSource.storeUserData(userId, uniqueId, token, deviceId);
  }

  Future<void> removeUserFCM(String userId, String uniqueId) async {
    await userFbDataSource.removeUserData(userId, uniqueId);
  }

  Future<List<String>> getUserDevicesFcm(String userId) async {
    List<String> fcmTokens = [];
    DatabaseEvent event = await userFbDataSource.getUserData(userId);
    if (event.snapshot.exists) {
      for (var token in event.snapshot.children) {
        final tokenData = token.value as Map<dynamic, dynamic>;
        fcmTokens.add(tokenData['token'].toString());
      }
    }
    return fcmTokens;
  }
}
