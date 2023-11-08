import 'dart:developer';
import 'package:either_dart/either.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_office/core/utilities/custom_widgets/custom_snack_bar.dart';
import 'package:my_office/features/employee_of_the_week/data/data_source/employee_fb_data_source.dart';
import '../../../attendance/presentation/view_model/staff_attendance_model.dart';

class EmployeeFbDataSourceImpl implements EmployeeFbDataSource {

  @override
  Future<List<StaffAttendanceModel>> allStaffNames() async {
    List<StaffAttendanceModel> allStaffs = [];

    var ref = FirebaseDatabase.instance.ref();
    var snapshot = await ref.child('staff').once();

    for (var uid in snapshot.snapshot.children) {
      var names = uid.value as Map<Object?, Object?>;
      final staffNames = StaffAttendanceModel(
        uid: uid.key.toString(),
        department: names['department'].toString(),
        name: names['name'].toString(),
        profileImage: names['profileImage'].toString(),
        emailId: names['email'].toString(),
      );
      if (staffNames.name != "Nikhil Deepak") {
        allStaffs.add(staffNames);
      }
    }

    return allStaffs;
  }


  @override
  Future<void> updatePrNameReason(context) async {
    TextEditingController employeeName = TextEditingController();
    TextEditingController reason = TextEditingController();
    List<StaffAttendanceModel> allStaffs = [];
    late String prNameToUid = '';

    var selectedEmployee =
    allStaffs.firstWhere((element) => element.name == employeeName.text);
    prNameToUid = selectedEmployee.uid;

    if (prNameToUid.isEmpty || reason.text.isEmpty) {
      CustomSnackBar.showErrorSnackbar(
          message: 'Enter all employee data!!',
          context: context,
      );
    } else {
      final ref = FirebaseDatabase.instance.ref();
      await ref.child('PRDashboard/employee_of_week').update({
        'person': prNameToUid,
        'reason': reason.text,
      });
      CustomSnackBar.showSuccessSnackbar(
          message: 'Best employee data has been updated!!',
          context: context,
      );
      Navigator.pop(context);
    }
  }
}
