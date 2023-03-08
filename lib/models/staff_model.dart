import 'package:hive_flutter/adapters.dart';

part 'staff_model.g.dart';

@HiveType(typeId: 0)
class StaffModel {
  @HiveField(0)
  final String uid;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String department;
  @HiveField(4)
  final String profilePic;

  StaffModel({
    required this.uid,
    required this.name,
    required this.department,
    required this.email,
    required this.profilePic,
  });
}
