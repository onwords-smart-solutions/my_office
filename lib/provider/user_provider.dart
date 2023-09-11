import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:my_office/database/hive_operations.dart';
import 'package:my_office/models/staff_model.dart';
import 'package:my_office/services/notification_service.dart';

class UserProvider with ChangeNotifier {
  final HiveOperations _hiveOperations = HiveOperations();

  StaffModel? _user;

  StaffModel? get user => _user;

  Future<void> initiateUser() async {
    final staff = await _hiveOperations.getStaffDetail();
    if (staff != null) {
      if (staff.uniqueId.isEmpty) {
        final id = generateRandomString(20);
        staff.uniqueId = id;
        _hiveOperations.updateStaffUniqueId(id);
      }
    }
    _user = staff;
    notifyListeners();
  }

  Future<void> addUser(StaffModel staff) async {
    if (staff.uniqueId.isEmpty) {
      final id = generateRandomString(20);
      staff.uniqueId = id;
    }
    await _hiveOperations.addStaffDetail(staff: staff);
    _user = staff;

    notifyListeners();
  }

  Future<void> updateImage(String url) async {
    if (_user != null) {
      _user!.profilePic = url;
      notifyListeners();
      _hiveOperations.updateStaffImage(url);
    }
  }

  Future<void> updateDOB(DateTime dob) async {
    if (_user != null) {
      final timeStamp = dob.millisecondsSinceEpoch;
      _user!.dob = timeStamp;
      notifyListeners();
      _hiveOperations.updateStaffDOB(timeStamp);
    }
  }

  Future<void> clearUser() async {
    if (_user != null) {
      await NotificationService().removeFCM(userId: _user!.uid, uniqueId: _user!.uniqueId);
    }
    await _hiveOperations.clearDetails();

    _user = null;
    notifyListeners();
  }
}

String generateRandomString(int length) {
  const charset = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final random = Random();
  final buffer = StringBuffer();

  for (var i = 0; i < length; i++) {
    buffer.write(charset[random.nextInt(charset.length)]);
  }
  return buffer.toString();
}
