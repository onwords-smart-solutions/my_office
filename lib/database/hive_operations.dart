import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_office/models/staff_model.dart';
import '../models/visit_model.dart';

ValueNotifier<List<VisitModel>> prVisits = ValueNotifier([]);

class HiveOperations with ChangeNotifier {
  Future<void> addStaffDetail({required StaffModel staff}) async {
    final userDB = await Hive.openBox<StaffModel>('user_db');
    await userDB.clear();
    await userDB.add(staff);
  }

//GETTING STAFF DATA
  Future<StaffModel?> getStaffDetail() async {
    final staff = await Hive.openBox<StaffModel>('user_db');
    if (staff.isNotEmpty) {
      final data = staff.values.first;
      return data;
    }
    return null;
  }

  Future<void> updateStaffImage(String url) async {
    final box = await Hive.openBox<StaffModel>('user_db');
    final staff = box.getAt(0);
    if (staff != null) {
      staff.profilePic = url;
      await box.deleteAt(0);
      await box.add(staff);
    }
  }


  Future<void> updateStaffUniqueId(String id) async {
    final box = await Hive.openBox<StaffModel>('user_db');
    final staff = box.getAt(0);
    if (staff != null) {
      staff.uniqueId = id;
      await box.deleteAt(0);
      await box.add(staff);
    }
  }

  Future<void> updateStaffDOB(int timeStamp) async {
    final box = await Hive.openBox<StaffModel>('user_db');
    final staff = box.getAt(0);
    if (staff != null) {
      staff.dob = timeStamp;
      await box.deleteAt(0);
      await box.add(staff);
    }
  }

  Future<void> updatePhoneNumber(int phone) async {
    final box = await Hive.openBox<StaffModel>('user_db');
    final staff = box.getAt(0);
    if(staff != null){
      staff.phoneNumber = phone;
      await box.deleteAt(0);
      await box.add(staff);
    }
  }

//CLEARING DATA
  Future<void> clearDetails() async {
    final userDB = await Hive.openBox<StaffModel>('user_db');
    userDB.deleteFromDisk();
  }

  //ADDING DATA FOR PR VISIT
  Future<void> addVisitEntry({required VisitModel visit}) async {
    final userDB = await Hive.openBox<VisitModel>('pr_db');
    final isAdded = userDB.containsKey(visit.customerPhoneNumber);
    if (!isAdded) {
      await userDB.put(visit.customerPhoneNumber, visit);
      prVisits.value.add(visit);
      prVisits.notifyListeners();
    }
  }

  //UPDATE PR VISIT ENTRY
  Future<void> updateVisitEntry({required VisitModel newVisitEntry}) async {
    final userDB = await Hive.openBox<VisitModel>('pr_db');
    int lastIndex = userDB.length - 1;
    if (lastIndex < 0) return;
    await userDB.delete(newVisitEntry.customerPhoneNumber);
    await userDB.put(newVisitEntry.customerPhoneNumber, newVisitEntry);
    getVisitEntry();
  }

  //GETTING DATA FOR PR VISIT
  Future<void> getVisitEntry() async {
    final userDB = await Hive.openBox<VisitModel>('pr_db');

    prVisits.value.clear();
    prVisits.value.addAll(userDB.values);
    prVisits.notifyListeners();
  }

  //DELETE ONE DATA FROM PR VISIT
  Future<void> deleteVisitEntry({required String phoneNumber}) async {
    final userDB = await Hive.openBox<VisitModel>('pr_db');
    userDB.delete(phoneNumber);
    getVisitEntry();
  }

  //CLEARING DATA FOR PR VISIT DB
  Future<void> clearPREntry() async {
    final userDB = await Hive.openBox<VisitModel>('pr_db');
    await userDB.deleteFromDisk();
    prVisits.value.clear();
    prVisits.notifyListeners();
  }
}
