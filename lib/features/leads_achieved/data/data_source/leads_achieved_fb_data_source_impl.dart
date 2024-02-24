import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:my_office/features/leads_achieved/data/data_source/leads_achieved_fb_data_source.dart';
import 'package:my_office/features/leads_achieved/data/model/leads_achieved_model.dart';

class LeadsAchievedDataSourceImpl implements LeadsAchievedDataSource{
  final ref = FirebaseDatabase.instance.ref();

  @override
  Future<List<LeadsAchievedModel>> getPRStaffNames() async {
    DatabaseEvent staffEvent = await ref.child('staff').once();
    List<LeadsAchievedModel> staffNames = [];
    for (var data in staffEvent.snapshot.children) {
      var fbData = data.value as Map<Object?, Object?>;
      if (fbData['department'] == 'PR') {
        final name = fbData['name'].toString();
        final dep = fbData['department'].toString();
        final emailId = fbData['email'].toString();
        final uid = data.key.toString();
        final leadsTarget = fbData['leads_target'].toString();
        final leadsAchieved = fbData['leads_achieved'].toString();
        final leadsAchievedModel = LeadsAchievedModel(
          name: name,
          dep: dep,
          emailId: emailId,
          uid: uid,
          leadsTarget: leadsTarget,
          leadsAchieved: leadsAchieved,
        );
        staffNames.add(leadsAchievedModel);
      }
    }
    return staffNames;
  }

  @override
  Future<List<String>> allPr() async {
    DatabaseEvent staffEvent = await ref.child('staff').once();
    List<LeadsAchievedModel> staffNames = [];
    List<String> namesOnly = [];
    for (var data in staffEvent.snapshot.children) {
      var fbData = data.value as Map<Object?, Object?>;
      if (fbData['department'] == 'PR') {
        final name = fbData['name'].toString();
        final dep = fbData['department'].toString();
        final emailId = fbData['email'].toString();
        final uid = data.key.toString();
        final leadsTarget = fbData['leads_target'].toString();
        final leadsAchieved = fbData['leads_achieved'].toString();
        final leadsAchievedModel = LeadsAchievedModel(
          name: name,
          dep: dep,
          emailId: emailId,
          uid: uid,
          leadsTarget: leadsTarget,
          leadsAchieved: leadsAchieved,
        );
        staffNames.add(leadsAchievedModel);
       namesOnly = staffNames.map((staff) => staff.name).toList();
      }
    }
    return namesOnly;
  }

  @override
  Future <List<String>> getManagementList() async {
    List<String> names = [];
      await ref.child('special_access/management').once().then((value) {
        if (value.snapshot.exists) {
          for (var mgmt in value.snapshot.children) {
            names.add(mgmt.value.toString());
          }
        }
      });
      return names;
  }

  @override
  Future<void> updateSaleTarget({
    required String uid,
    required String targetLeads,
    required String achievedLeads,
  }) async {
    return await ref.child('staff/$uid').update({
      'leads_target': targetLeads,
      'leads_achieved': achievedLeads,
    });
  }
}