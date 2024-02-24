import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:my_office/features/leads_achieved/data/data_source/leads_achieved_fb_data_source.dart';
import 'package:my_office/features/leads_achieved/data/data_source/leads_achieved_fb_data_source_impl.dart';
import 'package:my_office/features/leads_achieved/data/repository/leads_achieved_repo_impl.dart';
import 'package:my_office/features/leads_achieved/domain/repository/leads_achieved_repository.dart';
import '../../../notifications/presentation/notification_view_model.dart';

class LeadsAchievedViewModel{

  late final LeadsAchievedDataSource leadsAchievedDataSource = LeadsAchievedDataSourceImpl();
  late final LeadsAchievedRepository leadsAchievedRepository = LeadsAchievedRepoImpl(leadsAchievedDataSource);
  final NotificationService _firebaseNotification = NotificationService();
  final FirebaseOperation _firebaseService = FirebaseOperation();

  Future<void> sendLeadsAchievedNotification(String title, String body, String name) async {
    List<String> members = [
      '58JIRnAbechEMJl8edlLvRzHcW52',
      // 'Ae6DcpP2XmbtEf88OA8oSHQVpFB2',
      // 'Vhbt8jIAfiaV1HxuWERLqJh7dbj2',
    ];
    final mgmt = await leadsAchievedRepository.getManagementList();
    final pr = await leadsAchievedRepository.allPr();

    List<String> names = [];
    // names.addAll(mgmt);
    // names.addAll(pr);

    final ids = await _firebaseService.getUserId(userNames: names);
    members.addAll(ids);

    for (var id in members) {
      final tokens = await _firebaseNotification.getDeviceFcm(userId: id);
      for (var token in tokens) {
        await _firebaseNotification.sendNotification(
            type: NotificationType.saleCount, title: title, body: body, token: token,);
      }
    }
  }
}

class FirebaseOperation {
  Future<List<String>> getUserId({required List<String> userNames}) async {
    List<String> id = [];
    await FirebaseDatabase.instance.ref('staff').once().then((value) {
      if (value.snapshot.exists) {
        for (var staff in value.snapshot.children) {
          if (userNames.contains(staff.child('name').value)) {
            id.add(staff.key.toString());
          }
        }
      }
    });
    log('Staff ids are $id');
    return id;
  }
}