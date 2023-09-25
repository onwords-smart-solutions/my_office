import 'package:hive_flutter/adapters.dart';

part 'staff_model.g.dart';

@HiveType(typeId: 0)
class StaffModel {
  @HiveField(0)
  String uid;
  @HiveField(1)
  String name;
  @HiveField(2)
  String email;
  @HiveField(3)
  String department;
  @HiveField(4)
  String profilePic;
  @HiveField(5)
  int dob;
  @HiveField(6)
  String uniqueId;
  @HiveField(7)
  int phoneNumber;

  StaffModel({
    required this.uid,
    required this.name,
    required this.department,
    required this.email,
    required this.profilePic,
    required this.dob,
    required this.phoneNumber,
    required this.uniqueId,
  });
}
