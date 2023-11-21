import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:my_office/features/pr_reminder/data/data_source/pr_reminder_fb_data_source.dart';
import 'package:my_office/features/pr_reminder/data/model/pr_reminder_model.dart';

class PrReminderFbDataSourceImpl implements PrReminderFbDataSource {
  @override
  Future<List<String>> getPRStaffNames() async {
    final ref = FirebaseDatabase.instance.ref().child('staff');
    DatabaseEvent event = await ref.once();
    List<String> staffNames = ['All Reminders', 'My Reminders'];

    for (var data in event.snapshot.children) {
      var fbData = data.value as Map<Object?, Object?>;
      if (fbData['department'] == 'PR') {
        staffNames.add(fbData['name'].toString());
      }
    }
    return staffNames;
  }

  @override
  Future<List<PrReminderModel>> getReminders(String selectedDate) async {
    final ref =
        FirebaseDatabase.instance.ref('customer_reminders/$selectedDate/');
    DatabaseEvent event = await ref.once();
    List<PrReminderModel> reminders = [];

    for (var customer in event.snapshot.children) {
      final allData = customer.value as Map<Object?, Object?>;
      reminders.add(PrReminderModel.fromMap(allData));
    }
    return reminders;
  }
}
