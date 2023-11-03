import 'package:firebase_database/firebase_database.dart';
import 'package:my_office/features/user/domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.uid,
    required super.dep,
    required super.email,
    required super.name,
    required super.dob,
    required super.mobile,
    required super.url,
  });

  factory UserModel.fromRealtimeDb(DataSnapshot user) {
    final userInfo = user.value as Map<Object?, Object?>;
    return UserModel(
      uid: user.key.toString(),
      email: userInfo['email'].toString(),
      name: userInfo['name'].toString(),
      dep: userInfo['department'].toString(),
      dob: int.parse(userInfo['dob'].toString()),
      mobile: int.parse(userInfo['mobile'].toString()),
      url: userInfo['profileImage'].toString() == 'null' ? '' : userInfo['profileImage'].toString(),
    );
  }
}
