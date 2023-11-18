import 'package:firebase_database/firebase_database.dart';

abstract class UserFbDataSource {
  Future<DatabaseEvent> getUserData(String userId);

  Future<void> removeUserData(String userId, String uniqueId);

  Future<void> storeUserData(
    String userId,
    String uniqueId,
    String token,
    String deviceId,
  );
}
