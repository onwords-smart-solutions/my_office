import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_office/features/pr_dashboard/data/data_source/pr_dash_fb_data_source.dart';

class PrDashFbDataSourceImpl implements PrDashFbDataSource {
  TextEditingController totalPrGetTarget = TextEditingController();
  TextEditingController totalPrTarget = TextEditingController();
  final ref = FirebaseDatabase.instance.ref();


  @override
  Future<Map<String, dynamic>> getPrDashboardData() async {
    DatabaseEvent event = await ref.child('PRDashboard').once();
    if (event.snapshot.exists) {
      Map<String, dynamic> result = {};
      for (var prTarget in event.snapshot.children) {
        if (prTarget.key!.contains('prtarget')) {
          final data = prTarget.value as Map<Object?, Object?>;
          data.forEach((key, value) {
            if (key is String) {
              result[key] = value;
            }
          });
          return result;
        }
      }
    }
    return {};
  }

  @override
  Future<void> updatePrDashboardData(String totalPrGetTarget, String totalPrTarget)async {
    await ref.child('PRDashboard/prtarget').update({
      'totalprgettarget': totalPrGetTarget,
      'totalprtarget': totalPrTarget,
    });
  }
}
