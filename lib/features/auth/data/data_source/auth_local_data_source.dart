import "dart:math";

import "package:shared_preferences/shared_preferences.dart";

class AuthLocalDataSourceImpl {
  final SharedPreferences _sharedPreferences;

  AuthLocalDataSourceImpl(this._sharedPreferences);

  final _id = "UNIQUE_ID";

  Future<String> getUniqueID() async {
    String? id = _sharedPreferences.getString(_id);
    if (id == null) {
      final newId = _generateRandomString(8);
      id = newId;
      await storeUniqueId(id);
    }
    return id;
  }

  Future<void> storeUniqueId(String id) async {
    await _sharedPreferences.setString(_id, id);
  }

  Future<void> clearCache() async => await _sharedPreferences.remove(_id);

  String _generateRandomString(int length) {
    const charset =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    final buffer = StringBuffer();

    for (var i = 0; i < length; i++) {
      buffer.write(charset[random.nextInt(charset.length)]);
    }
    return buffer.toString();
  }
}
