import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_office/features/hr_access/data/data_source/hr_access_fb_data_source.dart';
import 'package:my_office/features/hr_access/data/model/hr_access_staff_model.dart';

class HrAccessFbDataSourceImpl implements HrAccessFbDataSource {
  final ref = FirebaseDatabase.instance.ref();
  final auth = FirebaseAuth.instance;

  @override
  Future<List<HrAccessModel>> staffDetails() async {
    final List<HrAccessModel> allDetails = [];
    await ref.child('staff').once().then((value) {
      for (var uid in value.snapshot.children) {
        var individualStaffDetails = uid.value as Map<Object?, Object?>;
        final staffs = HrAccessModel(
          uid: uid.key.toString(),
          name: individualStaffDetails['name'].toString(),
          email: individualStaffDetails['email'].toString(),
          department: individualStaffDetails['department'].toString(),
          profilePic: individualStaffDetails['profileImage'] != null
              ? individualStaffDetails['profileImage'].toString()
              : '',
          mobile: individualStaffDetails['mobile'] != null
              ? int.parse(individualStaffDetails['mobile'].toString())
              : 0,
          dob: individualStaffDetails['dob'] != null
              ? int.parse(individualStaffDetails['dob'].toString())
              : 0,
          punchIn: individualStaffDetails['punch_in'].toString(),
          punchOut: individualStaffDetails['punch_out'].toString(),
        );
        if (staffs.name != 'Nikhil Deepak') {
          allDetails.add(staffs);
        }
      }
    });
    return allDetails;
  }

  @override
  Future<void> updateTimingForEmployees({
    required String uid,
    required String punchIn,
    required String punchOut,
  }) async {
    return await ref.child('staff/$uid').update({
      'punch_in': punchIn,
      'punch_out': punchOut,
    });
  }

  @override
  Future<HrAccessModel?> createAccount({
    required String name,
    required String email,
    required String dep,
  }) async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: 'onwords8182',
      );
      credential.user!.displayName;
      await ref.child('staff/${credential.user!.uid}').set({
        'department' : dep,
        'email' : email,
        'name' : name,
        'punch_in': '09:00',
        'punch_out': '18:00',
      });
      await ref.child('staff_details/${credential.user!.uid}').set({
        'department': dep,
        'email': email,
        'name': name,
      });
      return HrAccessModel(
        name: name,
        email: email,
        department: dep,
        punchIn: '',
        punchOut: '',
        uid: credential.user!.uid,
      );
    } on FirebaseException catch (e) {
      print('Firebase Error: ${e.message}');
      return null;
    }
  }
}
