import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_office/models/staff_model.dart';
import '../models/visit_model.dart';

ValueNotifier<List<VisitModel>> prVisits = ValueNotifier([]);


class HiveOperations with ChangeNotifier{

  Future<void> addStaffDetail({required StaffModel staff}) async {
    final userDB = await Hive.openBox<StaffModel>('user_db');
    await userDB.add(staff);
  }

//GETTING STAFF DATA
  Future<StaffModel> getStaffDetail() async {
    final staff = await Hive.openBox<StaffModel>('user_db');
    return staff.values.first;
  }

//CLEARING DATA
  Future<void> clearDetails() async {
    final userDB = await Hive.openBox<StaffModel>('user_db');
    userDB.deleteFromDisk();
  }

  //ADDING DATA FOR PR VISIT
Future<void> addVisitEntry({required String phoneNumber}) async {
  final userDB = await Hive.openBox<StaffModel>('pr_db');
}
}


