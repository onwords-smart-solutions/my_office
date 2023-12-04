import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:my_office/features/food_count/data/data_source/food_count_fb_data_source.dart';
import 'package:my_office/features/food_count/data/model/food_count_model.dart';

class FoodCountFbDataSourceImpl implements FoodCountFbDataSource {
  final ref = FirebaseDatabase.instance.ref();

  @override
  Future<List<FoodCountModel>> getAllFoodCounts(String month) async {
    final staffs = await ref.child('staff').once();
    List<FoodCountModel> allFoodCountList = [];

    for (var staff in staffs.snapshot.children) {
      final staffInfo = staff.value as Map<Object?, Object?>;
      final name = staffInfo['name'].toString();
      final dept = staffInfo['department'].toString();
      final email = staffInfo['email'].toString();
      final url = staffInfo['profileImage']?.toString() ?? '';

      final foodDetails = await getFoodCountByStaffName(name,month);
      if (foodDetails.isNotEmpty) {
        allFoodCountList.add(
          FoodCountModel(
            name: name,
            department: dept,
            url: url,
            email: email,
            foodDates: foodDetails,
            month: month,
          ),
        );
      }
    }
    return allFoodCountList;
  }

  @override
  Future<List<dynamic>> getFoodCountByStaffName(String staffName, String month) async {
    log('Month data is $month');
    List<dynamic> staffLunchData = [];
    final currentMonthFormat =
        '${DateTime.now().year}-$month';
    final refreshmentsSnapshot = await ref.child('refreshments').once();

    if (refreshmentsSnapshot.snapshot.exists) {
      for (var detail in refreshmentsSnapshot.snapshot.children) {
        final dividedFormat = detail.key!.substring(0, 7);
        if (dividedFormat == currentMonthFormat) {
          final data = detail.value as Map<Object?, Object?>;
          if (data['Lunch'] != null) {
            final lunchData = data['Lunch'] as Map<Object?, Object?>;
            final lunchList = lunchData['lunch_list'] as Map<Object?, Object?>;
            for (var staff in lunchList.values) {
              if (staff.toString() == staffName) {
                staffLunchData.add(detail.key);
              }
            }
          }
        }
      }
    }
    return staffLunchData;
  }
}
