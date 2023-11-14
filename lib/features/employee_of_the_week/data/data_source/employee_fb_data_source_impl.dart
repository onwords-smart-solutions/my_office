import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_office/features/employee_of_the_week/data/data_source/employee_fb_data_source.dart';
import '../model/employee_model.dart';

class EmployeeFbDataSourceImpl implements EmployeeFbDataSource {

  final ref = FirebaseDatabase.instance.ref();

  @override
  Future<List<EmployeeModel>> allStaffNames() async {
    List<EmployeeModel> allStaffs = [];

    var ref = FirebaseDatabase.instance.ref();
    var snapshot = await ref.child('staff').once();

    for (var uid in snapshot.snapshot.children) {
      var names = uid.value as Map<Object?, Object?>;
      final staffNames = EmployeeModel(
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
  Future<void> updateEmployeeOfWeek(String employeeUid, String reason) async {
    await ref.child('PRDashboard/employee_of_week').update({
      'person': employeeUid,
      'reason': reason,
    });
  }
}
