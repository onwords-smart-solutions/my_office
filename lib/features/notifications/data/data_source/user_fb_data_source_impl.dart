import 'package:firebase_database/firebase_database.dart';
import 'package:my_office/features/notifications/data/data_source/user_fb_data_source.dart';

class UserFbDataSourceImpl implements UserFbDataSource {
  final DatabaseReference _userRef =
      FirebaseDatabase.instance.ref().child('users');

  @override
  Future<DatabaseEvent> getUserData(String userId) async {
    return _userRef.child(userId).once();
  }

  @override
  Future<void> removeUserData(String userId, String uniqueId) async {
    await _userRef.child('$userId/$uniqueId').remove();
  }

  @override
  Future<void> storeUserData(
    String userId,
    String uniqueId,
    String token,
    String deviceId,
  ) async {
    await _userRef
        .child('$userId/$uniqueId')
        .set({'token': token, 'deviceId': deviceId});
  }
}
