import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:my_office/features/hr_access/data/data_source/hr_access_fb_data_source.dart';
import 'package:my_office/features/hr_access/data/model/hr_access_staff_model.dart';

class HrAccessFbDataSourceImpl implements HrAccessFbDataSource{
  final ref = FirebaseDatabase.instance.ref();

  @override
  Future<List<HrAccessModel>> staffDetails() async{
    final List<HrAccessModel> allDetails = [];
    await ref.child('staff').once().then((value) {
      for(var uid in value.snapshot.children){
        var individualStaffDetails = uid.value as Map<Object?, Object?>;
        final staffs = HrAccessModel(
            uid: uid.key.toString(),
            name: individualStaffDetails['name'].toString(),
            email: individualStaffDetails['email'].toString(),
          department: individualStaffDetails['department'].toString(),
          profilePic: individualStaffDetails['profileImage'] != null ?individualStaffDetails['profileImage'].toString() : '',
          mobile: individualStaffDetails['mobile'] != null ? int.parse(individualStaffDetails['mobile'].toString()) : 0,
          dob: individualStaffDetails['dob'] != null ? int.parse(individualStaffDetails['dob'].toString()) : 0,
        );
        if(staffs.name != 'Nikhil Deepak'){
          allDetails.add(staffs);
        }
      }
      log('Data is $allDetails');
    });
    return allDetails;
  }
}