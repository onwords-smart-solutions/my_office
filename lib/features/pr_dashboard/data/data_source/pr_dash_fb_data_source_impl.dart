import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_office/core/utilities/custom_widgets/custom_snack_bar.dart';
import 'package:my_office/features/pr_dashboard/data/data_source/pr_dash_fb_data_source.dart';

import '../../domain/entity/pr_dash_entity.dart';

class PrDashFbDataSourceImpl implements PrDashFbDataSource{

  TextEditingController totalPrGetTarget = TextEditingController();
  TextEditingController totalPrTarget = TextEditingController();
  final FirebaseDatabase database;

  PrDashFbDataSourceImpl(this.database);

  @override
  Future<PrDashboardData> fetchPrDashboardData() async {
    final ref = database.ref();
    final snapshot = await ref.child('PRDashboard').once();

    if (snapshot.snapshot.exists) {
      for (var prTarget in snapshot.snapshot.children) {
        if (prTarget.key!.contains('prtarget')) {
          final data = prTarget.value as Map<Object?, Object?>;
          return PrDashboardData(
            totalPrGetTarget: data['totalprgettarget'].toString(),
            totalPrTarget: data['totalprtarget'].toString(),
          );
        }
      }
    }
    throw Exception('PRDashboard data not found');
  }

  @override
  Future<void> updatePrDashboard(context) async {
    if(totalPrGetTarget.text.isEmpty || totalPrTarget.text.isEmpty){
      CustomSnackBar.showErrorSnackbar(
          message: 'Enter all PR data',
          context: context,
      );
    }
    else{
      final ref = FirebaseDatabase.instance.ref();
      await ref.child('PRDashboard/prtarget').update({
        'totalprgettarget': totalPrGetTarget.text,
        'totalprtarget': totalPrTarget.text,
      });
      CustomSnackBar.showErrorSnackbar(
        message: 'PR data has been updated!!',
        context: context,
      );
      Navigator.pop(context);
    }
  }

}