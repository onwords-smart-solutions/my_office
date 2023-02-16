import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_office/models/staff_model.dart';

ValueNotifier<List<StaffModel>> staffDetails = ValueNotifier([]);



class HiveOperations with ChangeNotifier{

  Future<void> addStaffDetail({required StaffModel staff}) async {
    final userDB = await Hive.openBox<StaffModel>('user_db');
    await userDB.add(staff);

    staffDetails.value.add(staff);
    staffDetails.notifyListeners();
  }

//GETTING STAFF DATA
  Future<void> getUStaffDetail() async {
    final userDB = await Hive.openBox<StaffModel>('user_db');
    staffDetails.value.clear();

    staffDetails.value.addAll(userDB.values);
    staffDetails.notifyListeners();
  }

//CLEARING DATA
  Future<void> clearDetails() async {
    final userDB = await Hive.openBox<StaffModel>('user_db');
    userDB.deleteFromDisk();
    staffDetails.value.clear();
    staffDetails.notifyListeners();
  }
}


